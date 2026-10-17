// Managed redirects from the admin, before serving the page (@core/kit-cms, Next 16 proxy).
import { redirectFor } from '@/lib/site/adapters/next';

export async function proxy(req: Request) {
  return (await redirectFor(req)) ?? undefined;
}

export const config = { matcher: ['/((?!_next|api|admin|favicon.ico|sitemap|robots.txt|llms.txt).*)'] };
