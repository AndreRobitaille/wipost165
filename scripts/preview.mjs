import { readFileSync, writeFileSync } from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const theme = path.join(root, 'wp-content/themes/post165');
const outArg = process.argv.indexOf('--out');
const out = outArg !== -1 ? process.argv[outArg + 1] : path.join(root, 'theme-preview.html');

const themeJson = JSON.parse(readFileSync(path.join(theme, 'theme.json'), 'utf8'));

// :root custom properties from palette, font families, font sizes, custom tokens
const vars = [];
for (const c of themeJson.settings.color.palette) vars.push(`--wp--preset--color--${c.slug}: ${c.color};`);
for (const f of themeJson.settings.typography.fontFamilies) vars.push(`--wp--preset--font-family--${f.slug}: ${f.fontFamily};`);
for (const s of themeJson.settings.typography.fontSizes) vars.push(`--wp--preset--font-size--${s.slug}: ${s.size};`);
if (themeJson.settings.custom?.goldLight) vars.push(`--wp--custom--gold-light: ${themeJson.settings.custom.goldLight};`);

// @font-face from fontFace src, inlined as base64 data URIs
const faces = [];
for (const f of themeJson.settings.typography.fontFamilies) {
  for (const face of f.fontFace ?? []) {
    const rel = face.src[0].replace('file:./', '');
    const b64 = readFileSync(path.join(theme, rel)).toString('base64');
    faces.push(`@font-face{font-family:${JSON.stringify(face.fontFamily)};font-style:${face.fontStyle};font-weight:${face.fontWeight};font-display:swap;src:url(data:font/woff2;base64,${b64}) format('woff2');}`);
  }
}

// stylesheet: strip theme header comment, inline the seal as a data URI
const seal = readFileSync(path.join(theme, 'assets/images/seal.svg'), 'utf8');
const sealUri = `data:image/svg+xml,${encodeURIComponent(seal)}`;
let css = readFileSync(path.join(theme, 'style.css'), 'utf8').replace(/\/\*[\s\S]*?\*\//, '');
css = css.replace(/url\((['"]?)assets\/images\/seal\.svg\1\)/g, `url("${sealUri}")`);

// pattern slug -> file
const patternFiles = {
  'post165/home-hero': 'patterns/home-hero.php',
  'post165/home-events': 'patterns/home-events.php',
  'post165/home-membership': 'patterns/home-membership.php',
  'post165/how-we-serve': 'patterns/how-we-serve.php',
  'post165/support-post-165': 'patterns/support-post-165.php',
  'post165/contact-card': 'patterns/contact-card.php',
};

const renderDynamicBlocks = (s) => {
  // site-title (self-closing dynamic block) -> a styled anchor
  s = s.replace(/<!-- wp:site-title[^>]*?\/-->/g, '<a class="wp-block-site-title" href="#">Robert E. Burns American Legion Post 165</a>');
  // navigation region -> a <nav> with anchors built from the navigation-link labels/urls
  s = s.replace(/<!-- wp:navigation[\s\S]*?<!-- \/wp:navigation -->/g, (block) => {
    const links = [...block.matchAll(/"label":"([^"]*)","url":"([^"]*)"/g)]
      .map(([, label, url]) => `<a href="${url}">${label}</a>`)
      .join('');
    return `<nav class="wp-block-navigation">${links}</nav>`;
  });
  return s;
};

const stripPhp = (s) =>
  s
    .replace(/<\?php\s+echo\s+esc_url\([^?]*\)\s*;\s*\?>/g, '#') // links -> '#'
    .replace(/<\?php[\s\S]*?\?>/g, '') // pattern header + anything else
    .trim();

const readPart = (rel) => renderDynamicBlocks(stripPhp(readFileSync(path.join(theme, rel), 'utf8')));

// assemble main from the front-page pattern list, in order
const main = Object.keys(patternFiles).map((slug) => readPart(patternFiles[slug])).join('\n');
const header = readPart('parts/header.html');
const footer = readPart('parts/footer.html');

const html = `<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Post 165 preview</title><style>:root{${vars.join('')}}${faces.join('')}
body{margin:0;font-family:var(--wp--preset--font-family--sans);}
.wp-block-group{box-sizing:border-box;}
.wp-block-group.alignwide,.wp-block-group[class*="constrained"]>*{max-width:1160px;margin-left:auto;margin-right:auto;}
:where(.wp-block-columns){display:flex;gap:1.5rem;flex-wrap:wrap;}
:where(.wp-block-column){flex:1;min-width:200px;}
.wp-block-buttons{display:flex;gap:0.6rem;flex-wrap:wrap;}
.wp-block-button__link{display:inline-block;background:var(--wp--preset--color--red);color:#fff;border-radius:999px;padding:0.8rem 1.4rem;font-weight:700;text-decoration:none;}
.has-navy-background-color{background:var(--wp--preset--color--navy);}
.has-cream-background-color{background:var(--wp--preset--color--cream);}
.has-white-background-color{background:var(--wp--preset--color--white);}
.has-white-color{color:#fff;}.has-navy-color{color:var(--wp--preset--color--navy);}
.has-hero-font-size{font-size:var(--wp--preset--font-size--hero);}
.has-large-font-size{font-size:var(--wp--preset--font-size--large);}
.has-medium-font-size{font-size:var(--wp--preset--font-size--medium);}
.has-small-font-size{font-size:var(--wp--preset--font-size--small);}
.has-x-large-font-size{font-size:var(--wp--preset--font-size--x-large);}
h1,h2,h3{font-family:var(--wp--preset--font-family--serif);color:var(--wp--preset--color--navy);line-height:1.1;letter-spacing:-0.01em;}
.has-white-color h1,.has-white-color h2,.has-white-color h3,.has-navy-background-color h2{color:#fff;}
a{color:var(--wp--preset--color--red);}
.wp-block-navigation{display:flex;gap:1.15rem;flex-wrap:wrap;list-style:none;margin:0;padding:0;align-items:center;}
.wp-block-site-title{font-family:var(--wp--preset--font-family--serif);font-weight:700;font-size:1.15rem;text-decoration:none;color:inherit;}
${css}</style></head><body>${header}<main>${main}</main>${footer}</body></html>`;

writeFileSync(out, html);
console.log(`Preview written to ${out}`);
