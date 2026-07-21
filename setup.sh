#!/usr/bin/env bash
set -e

mkdir -p agentjunky && cd agentjunky

mkdir -p src/content/posts
mkdir -p src/layouts
mkdir -p src/pages/posts
mkdir -p src/styles

# .gitignore
cat > .gitignore << 'EOF'
node_modules/
dist/
.astro/
.env
EOF

# package.json
cat > package.json << 'EOF'
{
  "name": "agentjunky",
  "type": "module",
  "version": "0.1.0",
  "scripts": {
    "dev": "astro dev",
    "build": "astro check && astro build",
    "preview": "astro preview"
  },
  "dependencies": {
    "@astrojs/mdx": "^3.1.0",
    "@astrojs/rss": "^4.0.9",
    "@astrojs/sitemap": "^3.2.1",
    "@astrojs/tailwind": "^5.1.3",
    "astro": "^4.16.0",
    "tailwindcss": "^3.4.14"
  },
  "devDependencies": {
    "@astrojs/check": "^0.9.4",
    "typescript": "^5.6.3"
  }
}
EOF

# astro.config.mjs
cat > astro.config.mjs << 'EOF'
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';
import tailwind from '@astrojs/tailwind';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://agentjunky.com',
  integrations: [mdx(), tailwind(), sitemap()],
});
EOF

# tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "extends": "astro/tsconfigs/strict",
  "include": [".astro/types.d.ts", "**/*"],
  "exclude": ["dist"]
}
EOF

# render.yaml
cat > render.yaml << 'EOF'
services:
  - type: web
    name: agentjunky
    runtime: static
    buildCommand: npm install && npm run build
    staticPublishPath: ./dist
    pullRequestPreviewsEnabled: true
EOF

# tailwind.config.mjs
cat > tailwind.config.mjs << 'EOF'
/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,ts,tsx}'],
  theme: {
    extend: {},
  },
  plugins: [require('@tailwindcss/typography')],
};
EOF

# src/content/config.ts
cat > src/content/config.ts << 'EOF'
import { defineCollection, z } from 'astro:content';

const posts = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    series: z.string().default('Agent Junky'),
    seriesNumber: z.number(),
    excerpt: z.string(),
    topics: z.array(z.string()),
    cloudProvider: z.enum(['google', 'aws', 'azure', 'multi', 'none']).default('none'),
    publishDate: z.date(),
    draft: z.boolean().default(false),
  }),
});

export const collections = { posts };
EOF

# first post
cat > src/content/posts/01-home-agent-lab-junky-style.mdx << 'EOF'
---
title: "Let's build a home agent lab, junky style"
seriesNumber: 1
excerpt: "Spinning up a real local agent lab — ADK, Vertex AI, and the wiring in between. First real build of the series, mistakes included."
topics: ["Agent foundations", "Google Cloud & ADK"]
cloudProvider: google
publishDate: 2026-07-21
draft: true
---

Not just consuming AI. Building it. Here's the home lab I'm running this whole series on top of.

## What we're building

## The stack

## Getting ADK running locally

## What broke (and why that's fine)
EOF

# src/styles/global.css
cat > src/styles/global.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# src/layouts/BaseLayout.astro
cat > src/layouts/BaseLayout.astro << 'EOF'
---
interface Props {
  title: string;
  description?: string;
}
const { title, description = 'Building intelligent agents. Sharing everything.' } = Astro.props;
---
<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width" />
  <title>{title} · Agent Junky</title>
  <meta name="description" content={description} />
</head>
<body class="bg-[#050b16] text-[#e8f1fb] font-sans">
  <slot />
</body>
</html>
EOF

# src/pages/index.astro
cat > src/pages/index.astro << 'EOF'
---
import { getCollection } from 'astro:content';
import BaseLayout from '../layouts/BaseLayout.astro';

const posts = (await getCollection('posts', ({ data }) => !data.draft))
  .sort((a, b) => a.data.seriesNumber - b.data.seriesNumber);
---
<BaseLayout title="Home">
  <main class="max-w-3xl mx-auto px-6 py-16">
    <h1 class="text-3xl font-medium mb-2">Agent Junky</h1>
    <p class="text-[#9db3cc] mb-10">Building intelligent agents. Sharing everything.</p>

    <ul class="space-y-6">
      {posts.map((post) => (
        <li class="border border-[#1b2c44] rounded-xl p-5">
          <p class="text-xs tracking-wide text-emerald-400 mb-1">
            SERIES #{post.data.seriesNumber}
          </p>
          <a href={`/posts/${post.id}/`} class="text-lg font-medium hover:underline">
            {post.data.title}
          </a>
          <p class="text-sm text-[#9db3cc] mt-2">{post.data.excerpt}</p>
        </li>
      ))}
    </ul>
  </main>
</BaseLayout>
EOF

# src/pages/posts/[slug].astro
cat > "src/pages/posts/[slug].astro" << 'EOF'
---
import { getCollection, render } from 'astro:content';
import BaseLayout from '../../layouts/BaseLayout.astro';

export async function getStaticPaths() {
  const posts = await getCollection('posts', ({ data }) => !data.draft);
  return posts.map((post) => ({
    params: { slug: post.id },
    props: { post },
  }));
}

const { post } = Astro.props;
const { Content } = await render(post);
---
<BaseLayout title={post.data.title} description={post.data.excerpt}>
  <article class="max-w-2xl mx-auto px-6 py-16 prose prose-invert">
    <p class="text-sm text-emerald-400 tracking-wide">
      SERIES #{post.data.seriesNumber}
    </p>
    <h1>{post.data.title}</h1>
    <Content />
  </article>
</BaseLayout>
EOF

echo "Scaffold created. Next steps:"
echo "  cd agentjunky"
echo "  npm install"
echo "  npm run dev"