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
