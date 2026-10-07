import { readFile, mkdir, writeFile, copyFile } from 'node:fs/promises';
const templates = JSON.parse(await readFile(new URL('./worker/templates.json', import.meta.url), 'utf8'));
const worker = await readFile(new URL('./worker/worker.mjs', import.meta.url), 'utf8');
await mkdir(new URL('./dist/server', import.meta.url), { recursive: true });
await mkdir(new URL('./dist/.openai', import.meta.url), { recursive: true });
await writeFile(new URL('./dist/server/index.js', import.meta.url), `const templates = ${JSON.stringify(templates)};\n${worker}\nexport default createWorker(templates);\n`);
await copyFile(new URL('./.openai/hosting.json', import.meta.url), new URL('./dist/.openai/hosting.json', import.meta.url));
