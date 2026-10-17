# Guide: launch a dropshipping store with GenPM

**From an empty folder to a store with supplier import, margins, product landing pages and Stripe checkout.** This guide
rebuilds the *Lumio* demo step by step. Your AI assistant (Claude Code, Cursor, Copilot…) can do the technical parts by
following the instructions every module ships with.

![Lumio home page](screens/home.jpg)

## What you get

- A fast storefront: **home, shop, product pages, cart and Stripe Checkout** (cards, Apple Pay, Google Pay).
- **Suppliers without an API**: import their catalog from a CSV, send them orders by email, enter tracking in the admin.
- **Prices from your margin**: cost × markup, charm rounding, minimum margin, EU "prior price" history for sale badges.
- **Product landing pages** (`/p/<slug>`) with *buy now*, real delivery dates and import notices *before* payment.
- **Marketing**: cookie banner, consent-gated GA4 / Meta / TikTok pixels with server events, A/B tests.
- **Admin `/admin`**: orders, shipping zones, discounts, reviews, supplier orders, exceptions and an estimated profit widget.
- All of it as source code in your repo. No platform fees; host it wherever you want.

## What you need

| What | Why | Cost |
|---|---|---|
| Node.js 20+ | Run the project | Free |
| Postgres ([Neon](https://neon.tech), Supabase or Docker) | Products, carts, orders | Free to start |
| A GitHub account | Admin sign-in | Free |
| A [Stripe](https://stripe.com) account (test mode first) | Payments | Per transaction |
| An AI assistant (optional) | Let it do the wiring | — |

## Step 1. Create the project and add the kit

```bash
npx create-next-app@latest my-store && cd my-store
curl -fsSL https://genpm.net/install.sh | sh      # Windows: irm https://genpm.net/install.ps1 | iex
genpm add @core/kit-dropshipping
```

GenPM shows the plan first: **37 modules**, their npm dependencies, environment variables and the optional Stripe MCP
server (only added if you say yes). The code lands in `src/lib` and `src/app/(cms|store|landing|dropshipping)`, pinned
to verified commits in `genpm.lock`. GenPM never runs third-party install scripts.

## Step 2. Let your AI integrate it

Run `genpm mcp setup` once, then ask your assistant:

> *"Integrate @core/kit-dropshipping following the AGENTS.md of kit-cms, kit-store, kit-landing and kit-dropshipping, in that order."*

Doing it by hand? Each kit's `AGENTS.md` lists the steps. In short: Next config and `tsconfig`, the env file, auth
routes, the `src/genpm/*.ts` registration files (each kit's `_templates/genpm.md` says which lines go where), the proxy,
migrations, and a root layout with `<CartLink />`, the cookie banner (`<SiteTracking />`) and `<CookieSettingsButton />`.
The demo repo has one commit with exactly these changes.

## Step 3. Database, env and first sign-in

```bash
cp .env.example .env.local   # DATABASE_URL, AUTH_SECRET, GITHUB_*, STRIPE_SECRET_KEY / STRIPE_WEBHOOK_SECRET (test),
                             # CART_COOKIE_SECRET, ORDER_LINK_SECRET, STORE_CURRENCY=EUR, STORAGE_*, EMAIL_FROM
npm i -D drizzle-kit tsx
npx drizzle-kit generate --config src/lib/db/drizzle.config.ts
node --env-file=.env.local node_modules/drizzle-kit/bin.cjs migrate --config src/lib/db/drizzle.config.ts
npm run dev
```

Create a GitHub OAuth app (callback `http://localhost:3000/auth/callback/github`), sign in at `/admin/login` and make
yourself the owner: `npx tsx --env-file=.env.local "src/app/(cms)/_scripts/create-owner.ts" you@example.com`.

## Step 4. Your margin rule

**Admin → Price rules → New price rule.** The demo uses one store-wide rule: markup `16000` basis points (cost × 2.6),
rounding `.90`, minimum margin `3000` (30 %). Imports fail without at least one rule, on purpose: no product ever goes
live without a price you decided.

## Step 5. Your supplier and catalog

**Admin → Suppliers → New supplier** with the `manual` integration, currency `USD` and settings `orderEmail` and
`shipsFrom` (2-letter country). Then **Import products from CSV** with one row per variant:

```csv
product_id,title,description,image_urls,option1_name,option1_value,variant_id,cost,stock,weight_grams,ship_min_days,ship_max_days
SH-1001,Sunset Lamp,"Projects a warm sunset glow…",https://…/lamp.jpg,Colour,Sunset,SH-1001-SUN,8.40,500,420,7,12
```

Products arrive as **drafts**: check texts, image rights and prices, then activate them. Set the exchange rate with
`SUPPLIER_FX_RATES={"base":"EUR","rates":{"USD":1.08}}`. The demo's Sunset Lamp costs $8.40 and sells for €20.90.

## Step 6. Shipping, legal pages and the landing

1. **Shipping zones and rates**: the demo ships free to Spain & Portugal (7–12 days) and €4.90 to the EU (free over €40).
2. **Legal pages**: `npx tsx "src/app/(store)/_scripts/seed-legal.ts"` creates terms, shipping, returns, privacy and
   cookies as drafts. Complete them and have them reviewed before publishing.
3. **Landing for your hero product**: create a *Landing page* with the product's slug (`sunset-lamp`) and blocks
   (hero, benefits, FAQ, countdown). `/p/sunset-lamp` shows them above the *buy now* box.

![Sunset Lamp landing page](screens/landing-top.jpg)

## Step 7. Payments and the first order

```bash
stripe listen --forward-to localhost:3000/api/stripe/webhook
```

Buy from `/p/<slug>` with the test card `4242 4242 4242 4242`. The webhook creates the order, the customer gets an
email, and the order shows up in **Supplier orders** pending approval. Approve it (or enable *send paid orders
automatically*), the supplier receives it by email, add the tracking number, and the customer gets the "shipped" email.

![Admin dashboard](screens/admin-top.jpg)

## Step 8. Go live

- Deploy to [Vercel](https://vercel.com) (or any Node host); Postgres on Neon; images on Cloudflare R2 or S3.
- Schedule `GET /api/cron` every minute with `Authorization: Bearer $CRON_SECRET`, then run
  `npx tsx "src/app/(dropshipping)/_scripts/setup-schedules.ts"` (supplier sync and tracking jobs).
- Stripe live keys and a live webhook endpoint `https://<your-domain>/api/stripe/webhook`.
- Pixels: set `META_PIXEL_ID` + `META_CAPI_TOKEN`, `TIKTOK_PIXEL_ID` or `GA4_MEASUREMENT_ID` + `GA4_API_SECRET` (see `src/lib/pixels/AGENTS.md`); they only fire after consent.

## Keep improving

- A/B test a landing: create an experiment with variants `a`/`b` and set its key on the landing.
- Updates: `genpm outdated` and `genpm update` merge new versions while keeping your edits.
- More modules: [genpm.net](https://genpm.net) · demo code: [github.com/GenPM-net/demo-dropshipping](https://github.com/GenPM-net/demo-dropshipping)
