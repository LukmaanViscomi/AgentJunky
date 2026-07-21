/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,ts,tsx}'],
  theme: {
    extend: {
      colors: {
        navy: '#050b16',
        accent: '#378ADD',
        muted: '#9db3cc',
        line: '#1b2c44',
      },
    },
  },
  plugins: [require('@tailwindcss/typography')],
};
