import { test, expect } from '@playwright/test';

test('add & list task', async ({ page }) => {
  await page.goto('/');
  await page.getByPlaceholder('Add a task').fill('Buy milk');
  await page.getByRole('button', { name: 'Add' }).click();
  await expect(page.locator('li')).toContainText('Buy milk');
});
