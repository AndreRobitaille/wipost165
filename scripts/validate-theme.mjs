import { existsSync, readFileSync } from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const themeDir = path.join(root, 'wp-content/themes/post165');

const requiredFiles = [
  'wp-content/themes/post165/style.css',
  'wp-content/themes/post165/functions.php',
  'wp-content/themes/post165/theme.json',
  'wp-content/themes/post165/templates/index.html',
  'wp-content/themes/post165/templates/front-page.html',
  'wp-content/themes/post165/templates/page.html',
  'wp-content/themes/post165/parts/header.html',
  'wp-content/themes/post165/parts/footer.html',
  'wp-content/themes/post165/patterns/home-hero.php',
  'wp-content/themes/post165/patterns/home-events.php',
  'wp-content/themes/post165/patterns/home-membership.php',
  'wp-content/themes/post165/patterns/how-we-serve.php',
  'wp-content/themes/post165/patterns/support-post-165.php',
  'wp-content/themes/post165/patterns/contact-card.php',
  'wp-content/themes/post165/inc/settings.php',
  'wp-content/themes/post165/inc/events.php',
  'wp-content/themes/post165/inc/blocks.php',
  'docs/wordpress/content-model.md',
  'docs/wordpress/setup.md',
  'docs/deployment/ftp-github-actions.md',
  '.github/workflows/deploy-theme.yml'
];

const requiredText = new Map([
  ['wp-content/themes/post165/style.css', ['Theme Name: Post 165', 'Text Domain: post165', 'Requires at least: 6.5', '.post165-ribbon', '.post165-seal', '.post165-strap', '.post165-board', '.post165-year', '.post165-join']],
  ['wp-content/themes/post165/functions.php', ['post165_setup', 'post165_register_pattern_categories', 'add_theme_support', 'wp_enqueue_style', "add_theme_support( 'custom-logo'", 'inc/settings.php', 'inc/events.php', 'inc/blocks.php']],
  ['wp-content/themes/post165/templates/front-page.html', ['wp:pattern {"slug":"post165/home-hero"', 'wp:pattern {"slug":"post165/home-events"']],
  ['wp-content/themes/post165/parts/header.html', ['wp:navigation', 'Robert E. Burns American Legion Post 165']],
  ['wp-content/themes/post165/parts/footer.html', ['wipost165@gmail.com', 'PO Box 11', 'First Tuesday']],
  ['wp-content/themes/post165/patterns/home-hero.php', ['Learn About Membership', 'View Events']],
  ['wp-content/themes/post165/patterns/home-events.php', ['Public Events', 'Post Meetings', 'Honor Guard']],
  ['wp-content/themes/post165/patterns/home-membership.php', ['veterans', 'families']],
  ['wp-content/themes/post165/patterns/how-we-serve.php', ['Veterans', 'Youth', 'Remembrance', 'Community']],
  ['wp-content/themes/post165/patterns/support-post-165.php', ['Support Post 165']],
  ['wp-content/themes/post165/inc/settings.php', ['post165_fact', 'post165_meeting_rule', 'post165_meeting_overrides', 'sanitize_email', 'manage_options']],
  ['wp-content/themes/post165/inc/events.php', ['post165_upcoming_entries', 'post165_quiet_season_note', 'post165_year_map', 'tribe_get_events']],
  ['wp-content/themes/post165/inc/blocks.php', ['post165/upcoming', 'post165/year-strip', 'post165/join-panel', 'register_block_type', 'render_callback', 'antispambot']],
  ['docs/wordpress/content-model.md', ['Git owns', 'WordPress owns', 'Event categories']],
  ['docs/wordpress/setup.md', ['The Events Calendar', 'Home', 'Events', 'Membership', 'About', 'Contact']],
  ['docs/deployment/ftp-github-actions.md', ['FTP_SERVER', 'FTP_USERNAME', 'FTP_PASSWORD']]
]);

const failures = [];

for (const relativePath of requiredFiles) {
  const absolutePath = path.join(root, relativePath);
  if (!existsSync(absolutePath)) {
    failures.push(`Missing required file: ${relativePath}`);
  }
}

for (const [relativePath, snippets] of requiredText.entries()) {
  const absolutePath = path.join(root, relativePath);
  if (!existsSync(absolutePath)) {
    continue;
  }

  const content = readFileSync(absolutePath, 'utf8');
  for (const snippet of snippets) {
    if (!content.includes(snippet)) {
      failures.push(`${relativePath} must include: ${snippet}`);
    }
  }
}

const themeJsonPath = path.join(themeDir, 'theme.json');
if (existsSync(themeJsonPath)) {
  try {
    const themeJson = JSON.parse(readFileSync(themeJsonPath, 'utf8'));
    const palette = themeJson?.settings?.color?.palette ?? [];
    const paletteSlugs = palette.map((color) => color.slug);
    for (const slug of ['navy', 'cream', 'gold', 'red']) {
      if (!paletteSlugs.includes(slug)) {
        failures.push(`theme.json color palette must include slug: ${slug}`);
      }
    }
  } catch (error) {
    failures.push(`theme.json must be valid JSON: ${error.message}`);
  }
}

if (failures.length > 0) {
  console.error('Theme validation failed:');
  for (const failure of failures) {
    console.error(`- ${failure}`);
  }
  process.exit(1);
}

console.log('Theme validation passed.');
