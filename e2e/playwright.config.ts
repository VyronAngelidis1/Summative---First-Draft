// @ts-check
import { defineConfig } from '@playwright/test';

export default defineConfig({
  use: {
    baseURL: process.env.E2E_BASE_URL || 'http://localhost:8000',
    headless: true,
  },
  testDir: './tests',
});
