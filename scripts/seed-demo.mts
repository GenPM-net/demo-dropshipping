// Demo content for Lumio (fictional dropshipping store): price rule, manual supplier, CSV catalog import,
// shipping, home page and the Sunset Lamp landing. Idempotent-ish: run once on an empty database.
// Usage: npx tsx --env-file=.env.local scripts/seed-demo.mts      Photos: Unsplash (Unsplash License).
import { readFileSync } from 'node:fs';
import '../src/genpm/index.ts';
import { seedEntry } from '../src/lib/content/index.ts';
import { upsertPriceRule } from '../src/lib/pricing/index.ts';
import { upsertRate, upsertZone } from '../src/lib/shipping/index.ts';
import { importProduct, parseSupplierCsv, upsertSupplier } from '../src/lib/suppliers/index.ts';
import { importRemoteImage } from '../src/lib/media/index.ts';

// 1) Margin rule first: imports fail without one. Cost × 2.6, charm rounding to .90, never below 30 % margin.
await upsertPriceRule({ name: 'Store-wide margin', scope: 'all', markupBps: 16_000, rounding: '.90', minMarginBps: 3_000 });

// 2) Manual supplier (no API): orders go by email, tracking is entered in the admin.
const supplier = await upsertSupplier({
  name: 'Shenzhen Home Gadgets',
  adapter: 'manual',
  currency: 'USD',
  config: { orderEmail: 'orders@supplier.example', shipsFrom: 'CN' },
});

// 3) Catalog from the supplier's CSV: photos are downloaded into the media library, prices come from the rule.
const csv = readFileSync(new URL('./supplier-catalog.csv', import.meta.url), 'utf8');
const slugs: Record<string, string> = {
  'SH-1001': 'sunset-lamp', 'SH-1002': 'portable-blender', 'SH-1003': 'reindeer-humidifier',
  'SH-1004': 'aroma-diffuser-orb', 'SH-1005': 'mini-hd-projector', 'SH-1006': 'retro-lantern-lamp',
};
for (const p of parseSupplierCsv(csv, 'USD')) {
  await importProduct(supplier.id, p, { slug: slugs[p.externalProductId]!, status: 'active', imageHosts: ['images.unsplash.com'], rates: { base: 'EUR', rates: { USD: 1.08 } } });
  console.log('imported', p.title);
}

// 4) Shipping: free standard shipping to Spain and Portugal, flat rate to the rest of the EU.
const iberia = await upsertZone({ name: 'Spain & Portugal', countries: ['ES', 'PT'] });
await upsertRate({ zoneId: iberia.id, name: 'Standard (tracked)', amount: 0, minDays: 7, maxDays: 12 });
const eu = await upsertZone({ name: 'Europe', countries: ['FR', 'DE', 'IT', 'NL', 'BE', 'IE', 'AT'], position: 1 });
await upsertRate({ zoneId: eu.id, name: 'Standard (tracked)', amount: 490, freeOver: 4000, minDays: 8, maxDays: 14 });

// 5) Site, menus, home page and the single-product landing for the hero product.
const hero = (await importRemoteImage('https://images.unsplash.com/photo-1708232981795-2baec1d6687b?w=1600&q=80&fm=jpg&fit=crop', { allowedHosts: ['images.unsplash.com'], alt: 'Sunset lamp glowing on a purple wall', folder: 'demo' })).id;
await seedEntry({ collection: 'site_settings', data: { name: 'Lumio', tagline: 'Little things that make home feel good', contactEmail: 'hello@example.com', social: [{ platform: 'tiktok', url: 'https://tiktok.com/' }] } });
await seedEntry({ collection: 'menus', slug: 'header', data: { items: [{ label: 'Shop', href: '/shop' }, { label: 'Sunset Lamp', href: '/p/sunset-lamp' }] } });
await seedEntry({ collection: 'menus', slug: 'footer', data: { items: [{ label: 'Shop', href: '/shop' }, { label: 'Shipping', href: '/shipping' }, { label: 'Returns', href: '/returns' }, { label: 'Privacy', href: '/privacy' }, { label: 'Cookies', href: '/cookies' }] } });
await seedEntry({
  collection: 'pages',
  slug: 'home',
  data: {
    title: 'Lumio',
    seo: { title: 'Lumio · Home gadgets that make you smile', description: 'Sunset lamps, portable blenders and cosy home gadgets with free tracked shipping.' },
    blocks: [
      { id: 'hero', type: 'hero', data: { eyebrow: 'Free shipping to Spain & Portugal', title: 'Little things that make home feel good.', subtitle: 'The sunset lamp everyone is talking about, and five more gadgets we love. 30-day returns.', image: hero, ctaLabel: 'Shop the Sunset Lamp', ctaHref: '/p/sunset-lamp', secondaryLabel: 'Browse all', secondaryHref: '/shop', align: 'start', asPageTitle: true } },
      { id: 'grid', type: 'product-grid', data: { title: 'Bestsellers', count: 6 } },
      { id: 'why', type: 'features', data: { title: 'Why Lumio', columns: 3, items: [
        { icon: '🚚', title: 'Free tracked shipping', text: 'Spain & Portugal in 7–12 days. Real delivery dates on every product.' },
        { icon: '↩️', title: '30-day returns', text: 'Not in love? Send it back, no questions asked.' },
        { icon: '🔒', title: 'Secure checkout', text: 'Card, Apple Pay and Google Pay through Stripe.' },
      ] } },
      { id: 'love', type: 'testimonials', data: { title: 'Customers love it', items: [
        { quote: 'The sunset lamp completely changed my bedroom. Arrived in 9 days.', author: 'Marta G.', rating: 5 },
        { quote: 'Use the blender every morning at the gym. Charges in an hour.', author: 'Javi R.', rating: 5 },
        { quote: 'Great little projector for movie nights with the kids.', author: 'Laura P.', rating: 4 },
      ] } },
    ],
  },
});
await seedEntry({
  collection: 'landings',
  slug: 'sunset-lamp',
  data: {
    title: 'Sunset Lamp',
    goal: 'click',
    layout: 'full',
    blocks: [
      { id: 'hero', type: 'hero', data: { eyebrow: 'Viral on TikTok · 4.8★ from 2,300 reviews', title: 'Turn any room into golden hour.', subtitle: 'The Sunset Lamp projects a warm, cinematic glow on your wall. Free tracked shipping to Spain & Portugal.', image: hero, ctaLabel: 'Get yours', ctaHref: '#buy', align: 'start', asPageTitle: true } },
      { id: 'why', type: 'benefits', data: { title: 'Golden hour, every night', items: [
        { text: '16 colours: sunset, rainbow, ocean and more' },
        { text: '180° rotating head: wall, ceiling or corner' },
        { text: 'Plug & glow: USB powered, no app, no setup' },
      ] } },
      { id: 'faq', type: 'faq', data: { title: 'Questions', structuredData: true, items: [
        { question: 'When will it arrive?', answer: 'Spain & Portugal: 7–12 days with tracking. You will see the exact range before paying.' },
        { question: 'Can I return it?', answer: 'Yes, within 30 days of delivery.' },
      ] } },
    ],
  },
}).catch((e) => console.warn('landing skipped:', e.message));
console.log('Lumio: demo content published');
process.exit(0);
