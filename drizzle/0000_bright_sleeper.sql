CREATE SEQUENCE "public"."order_number_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 9223372036854775807 START WITH 1001 CACHE 1;--> statement-breakpoint
CREATE TABLE "admin_audit" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"resource" text NOT NULL,
	"record_id" text,
	"action" text NOT NULL,
	"diff" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "rate_limits" (
	"key" text PRIMARY KEY NOT NULL,
	"window_start" timestamp with time zone NOT NULL,
	"count" integer NOT NULL,
	"expires_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "auth_sessions" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "oauth_accounts" (
	"provider" text NOT NULL,
	"provider_user_id" text NOT NULL,
	"user_id" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "oauth_accounts_provider_provider_user_id_pk" PRIMARY KEY("provider","provider_user_id")
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" text PRIMARY KEY NOT NULL,
	"email" text,
	"name" text,
	"avatar_url" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "users_email_unique" UNIQUE("email")
);
--> statement-breakpoint
CREATE TABLE "cart_lines" (
	"cart_id" text NOT NULL,
	"variant_id" text NOT NULL,
	"quantity" integer NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "cart_lines_cart_id_variant_id_pk" PRIMARY KEY("cart_id","variant_id")
);
--> statement-breakpoint
CREATE TABLE "carts" (
	"id" text PRIMARY KEY NOT NULL,
	"user_id" text,
	"currency" text NOT NULL,
	"discount_codes" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"meta" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "product_categories" (
	"id" text PRIMARY KEY NOT NULL,
	"slug" text NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"parent_id" text,
	"position" integer DEFAULT 0 NOT NULL,
	"translations" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "product_categories_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "product_collection_items" (
	"collection_id" text NOT NULL,
	"product_id" text NOT NULL,
	"position" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "product_collection_items_collection_id_product_id_pk" PRIMARY KEY("collection_id","product_id")
);
--> statement-breakpoint
CREATE TABLE "product_collections" (
	"id" text PRIMARY KEY NOT NULL,
	"slug" text NOT NULL,
	"name" text NOT NULL,
	"description" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "product_collections_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "product_category_links" (
	"product_id" text NOT NULL,
	"category_id" text NOT NULL,
	CONSTRAINT "product_category_links_product_id_category_id_pk" PRIMARY KEY("product_id","category_id")
);
--> statement-breakpoint
CREATE TABLE "product_media" (
	"product_id" text NOT NULL,
	"media_id" text NOT NULL,
	"position" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "product_media_product_id_media_id_pk" PRIMARY KEY("product_id","media_id")
);
--> statement-breakpoint
CREATE TABLE "product_variants" (
	"id" text PRIMARY KEY NOT NULL,
	"product_id" text NOT NULL,
	"sku" text,
	"title" text DEFAULT '' NOT NULL,
	"options" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"price_amount" integer NOT NULL,
	"compare_at_amount" integer,
	"cost_amount" integer,
	"currency" text NOT NULL,
	"stock" integer DEFAULT 0 NOT NULL,
	"track_stock" boolean DEFAULT true NOT NULL,
	"allow_backorder" boolean DEFAULT false NOT NULL,
	"low_stock_threshold" integer DEFAULT 3 NOT NULL,
	"weight_grams" integer,
	"position" integer DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"media_id" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "product_variants_sku_unique" UNIQUE("sku")
);
--> statement-breakpoint
CREATE TABLE "products" (
	"id" text PRIMARY KEY NOT NULL,
	"slug" text NOT NULL,
	"name" text NOT NULL,
	"description" jsonb,
	"status" text DEFAULT 'draft' NOT NULL,
	"kind" text DEFAULT 'physical' NOT NULL,
	"brand" text,
	"options" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"tags" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"attributes" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"translations" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"seo_title" text,
	"seo_description" text,
	"published_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "products_slug_unique" UNIQUE("slug")
);
--> statement-breakpoint
CREATE TABLE "checkout_sessions" (
	"id" text PRIMARY KEY NOT NULL,
	"cart_id" text NOT NULL,
	"user_id" text,
	"email" text NOT NULL,
	"locale" text,
	"currency" text NOT NULL,
	"total" integer NOT NULL,
	"snapshot" jsonb NOT NULL,
	"status" text DEFAULT 'open' NOT NULL,
	"order_id" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "comment_bans" (
	"id" text PRIMARY KEY NOT NULL,
	"subject" text NOT NULL,
	"reason" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "comments" (
	"id" text PRIMARY KEY NOT NULL,
	"entity_type" text NOT NULL,
	"entity_id" text NOT NULL,
	"parent_id" text,
	"author_id" text,
	"author_name" text NOT NULL,
	"guest_email_hash" text,
	"body" text NOT NULL,
	"rating" integer,
	"status" text DEFAULT 'pending' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "consent_records" (
	"id" text PRIMARY KEY NOT NULL,
	"subject_id" text NOT NULL,
	"choices" jsonb NOT NULL,
	"policy_version" text NOT NULL,
	"action" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "content_entries" (
	"id" text PRIMARY KEY NOT NULL,
	"collection" text NOT NULL,
	"slug" text NOT NULL,
	"locale" text NOT NULL,
	"group_id" text NOT NULL,
	"status" text DEFAULT 'draft' NOT NULL,
	"data" jsonb,
	"draft" jsonb,
	"author_id" text,
	"published_at" timestamp with time zone,
	"scheduled_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "content_revisions" (
	"id" text PRIMARY KEY NOT NULL,
	"entry_id" text NOT NULL,
	"data" jsonb NOT NULL,
	"author_id" text,
	"message" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "discount_redemptions" (
	"id" text PRIMARY KEY NOT NULL,
	"discount_id" text NOT NULL,
	"order_id" text NOT NULL,
	"email" text NOT NULL,
	"user_id" text,
	"amount" integer NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "discounts" (
	"id" text PRIMARY KEY NOT NULL,
	"code" text,
	"name" text NOT NULL,
	"type" text NOT NULL,
	"value" integer DEFAULT 0 NOT NULL,
	"min_subtotal" integer,
	"product_slugs" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"category_slugs" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"first_order_only" boolean DEFAULT false NOT NULL,
	"usage_limit" integer,
	"per_customer_limit" integer,
	"combinable" boolean DEFAULT false NOT NULL,
	"starts_at" timestamp with time zone,
	"ends_at" timestamp with time zone,
	"active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "discounts_code_unique" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "experiment_participants" (
	"experiment_id" text NOT NULL,
	"visitor" text NOT NULL,
	"variant" text NOT NULL,
	"exposed_at" timestamp with time zone DEFAULT now() NOT NULL,
	"converted_at" timestamp with time zone,
	CONSTRAINT "experiment_participants_experiment_id_visitor_pk" PRIMARY KEY("experiment_id","visitor")
);
--> statement-breakpoint
CREATE TABLE "experiments" (
	"id" text PRIMARY KEY NOT NULL,
	"key" text NOT NULL,
	"name" text NOT NULL,
	"status" text DEFAULT 'draft' NOT NULL,
	"variants" jsonb NOT NULL,
	"goal" text NOT NULL,
	"started_at" timestamp with time zone,
	"stopped_at" timestamp with time zone,
	"results" jsonb,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "experiments_key_unique" UNIQUE("key")
);
--> statement-breakpoint
CREATE TABLE "form_submissions" (
	"id" text PRIMARY KEY NOT NULL,
	"form_key" text NOT NULL,
	"data" jsonb NOT NULL,
	"consent_version" text,
	"source_path" text,
	"utm" jsonb,
	"processed" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"status" text DEFAULT 'new' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "job_schedules" (
	"type" text PRIMARY KEY NOT NULL,
	"cron" text NOT NULL,
	"timezone" text DEFAULT 'UTC' NOT NULL,
	"payload" jsonb NOT NULL,
	"next_run_at" timestamp with time zone NOT NULL,
	"last_run_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "jobs" (
	"id" text PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"payload" jsonb NOT NULL,
	"status" text DEFAULT 'queued' NOT NULL,
	"run_at" timestamp with time zone DEFAULT now() NOT NULL,
	"attempts" integer DEFAULT 0 NOT NULL,
	"max_attempts" integer DEFAULT 5 NOT NULL,
	"locked_until" timestamp with time zone,
	"last_error" text,
	"dedupe_key" text,
	"finished_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "media" (
	"id" text PRIMARY KEY NOT NULL,
	"key" text NOT NULL,
	"filename" text NOT NULL,
	"mime" text NOT NULL,
	"size" integer NOT NULL,
	"width" integer,
	"height" integer,
	"alt" text DEFAULT '' NOT NULL,
	"focal_x" real DEFAULT 0.5 NOT NULL,
	"focal_y" real DEFAULT 0.5 NOT NULL,
	"folder" text DEFAULT '' NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"uploaded_by" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "media_key_unique" UNIQUE("key")
);
--> statement-breakpoint
CREATE TABLE "order_fulfillments" (
	"id" text PRIMARY KEY NOT NULL,
	"order_id" text NOT NULL,
	"lines" jsonb NOT NULL,
	"status" text DEFAULT 'shipped' NOT NULL,
	"carrier" text,
	"tracking_number" text,
	"tracking_url" text,
	"source" text DEFAULT 'manual' NOT NULL,
	"delivered_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "order_events" (
	"id" text PRIMARY KEY NOT NULL,
	"order_id" text NOT NULL,
	"type" text NOT NULL,
	"data" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"actor" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "order_lines" (
	"id" text PRIMARY KEY NOT NULL,
	"order_id" text NOT NULL,
	"variant_id" text,
	"product_id" text,
	"sku" text,
	"name" text NOT NULL,
	"title" text DEFAULT '' NOT NULL,
	"kind" text DEFAULT 'physical' NOT NULL,
	"quantity" integer NOT NULL,
	"unit_price" integer NOT NULL,
	"subtotal" integer NOT NULL,
	"discount" integer DEFAULT 0 NOT NULL,
	"total" integer NOT NULL,
	"fulfilled_quantity" integer DEFAULT 0 NOT NULL,
	"refunded_quantity" integer DEFAULT 0 NOT NULL,
	"position" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "orders" (
	"id" text PRIMARY KEY NOT NULL,
	"number" text NOT NULL,
	"status" text DEFAULT 'pending' NOT NULL,
	"fulfillment_status" text DEFAULT 'unfulfilled' NOT NULL,
	"email" text NOT NULL,
	"user_id" text,
	"locale" text,
	"currency" text NOT NULL,
	"subtotal" integer NOT NULL,
	"discount_total" integer DEFAULT 0 NOT NULL,
	"shipping_total" integer DEFAULT 0 NOT NULL,
	"tax_total" integer DEFAULT 0 NOT NULL,
	"total" integer NOT NULL,
	"refunded_total" integer DEFAULT 0 NOT NULL,
	"discounts" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"shipping_method" jsonb,
	"shipping_address" jsonb,
	"billing_address" jsonb,
	"customer_note" text,
	"payment_provider" text,
	"payment_ref" text,
	"cart_id" text,
	"paid_at" timestamp with time zone,
	"cancelled_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "orders_number_unique" UNIQUE("number"),
	CONSTRAINT "orders_cart_id_unique" UNIQUE("cart_id")
);
--> statement-breakpoint
CREATE TABLE "order_refunds" (
	"id" text PRIMARY KEY NOT NULL,
	"order_id" text NOT NULL,
	"amount" integer NOT NULL,
	"reason" text,
	"lines" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"restocked" boolean DEFAULT false NOT NULL,
	"provider_ref" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "pixel_attributions" (
	"key" text PRIMARY KEY NOT NULL,
	"data" jsonb NOT NULL,
	"expires_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "price_history" (
	"id" text PRIMARY KEY NOT NULL,
	"variant_id" text NOT NULL,
	"amount" integer NOT NULL,
	"currency" text NOT NULL,
	"valid_from" timestamp with time zone NOT NULL,
	"valid_to" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "price_rules" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"scope" text DEFAULT 'all' NOT NULL,
	"scope_value" text,
	"min_cost" integer,
	"max_cost" integer,
	"markup_bps" integer DEFAULT 0 NOT NULL,
	"fixed_add" integer DEFAULT 0 NOT NULL,
	"rounding" text DEFAULT '.99' NOT NULL,
	"min_margin_bps" integer DEFAULT 1000 NOT NULL,
	"priority" integer DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "roles" (
	"id" text PRIMARY KEY NOT NULL,
	"key" text NOT NULL,
	"label" text NOT NULL,
	"permissions" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"rank" integer DEFAULT 0 NOT NULL,
	"system" boolean DEFAULT false NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "roles_key_unique" UNIQUE("key")
);
--> statement-breakpoint
CREATE TABLE "user_roles" (
	"user_id" text NOT NULL,
	"role_id" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "user_roles_user_id_role_id_pk" PRIMARY KEY("user_id","role_id")
);
--> statement-breakpoint
CREATE TABLE "review_meta" (
	"comment_id" text PRIMARY KEY NOT NULL,
	"product_id" text NOT NULL,
	"verified" boolean DEFAULT false NOT NULL,
	"order_id" text,
	"source" text DEFAULT 'site' NOT NULL,
	"photos" jsonb DEFAULT '[]'::jsonb NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "review_stats" (
	"product_id" text PRIMARY KEY NOT NULL,
	"count" integer DEFAULT 0 NOT NULL,
	"average" integer DEFAULT 0 NOT NULL,
	"histogram" jsonb DEFAULT '[0,0,0,0,0]'::jsonb NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "search_documents" (
	"type" text NOT NULL,
	"id" text NOT NULL,
	"locale" text NOT NULL,
	"url" text NOT NULL,
	"title" text NOT NULL,
	"body" text NOT NULL,
	"config" text NOT NULL,
	"tsv" "tsvector" NOT NULL,
	"indexed_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "search_documents_type_id_pk" PRIMARY KEY("type","id")
);
--> statement-breakpoint
CREATE TABLE "shipping_rates" (
	"id" text PRIMARY KEY NOT NULL,
	"zone_id" text NOT NULL,
	"name" text NOT NULL,
	"amount" integer NOT NULL,
	"free_over" integer,
	"min_weight_grams" integer,
	"max_weight_grams" integer,
	"min_subtotal" integer,
	"max_subtotal" integer,
	"min_days" integer,
	"max_days" integer,
	"active" boolean DEFAULT true NOT NULL,
	"position" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "shipping_zones" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"countries" jsonb NOT NULL,
	"position" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "redirects" (
	"id" text PRIMARY KEY NOT NULL,
	"from_path" text NOT NULL,
	"to" text NOT NULL,
	"status" integer DEFAULT 301 NOT NULL,
	"hits" integer DEFAULT 0 NOT NULL,
	"last_hit_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "redirects_from_path_unique" UNIQUE("from_path")
);
--> statement-breakpoint
CREATE TABLE "stripe_events" (
	"id" text PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"processed_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "supplier_exceptions" (
	"id" text PRIMARY KEY NOT NULL,
	"type" text NOT NULL,
	"supplier_id" text,
	"variant_id" text,
	"order_id" text,
	"message" text NOT NULL,
	"data" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"status" text DEFAULT 'open' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "supplier_orders" (
	"id" text PRIMARY KEY NOT NULL,
	"order_id" text NOT NULL,
	"supplier_id" text NOT NULL,
	"status" text NOT NULL,
	"lines" jsonb NOT NULL,
	"external_ref" text,
	"error" text,
	"attempts" integer DEFAULT 0 NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "supplier_products" (
	"variant_id" text PRIMARY KEY NOT NULL,
	"supplier_id" text NOT NULL,
	"external_product_id" text NOT NULL,
	"external_variant_id" text NOT NULL,
	"cost" integer NOT NULL,
	"currency" text NOT NULL,
	"shipping_days_min" integer,
	"shipping_days_max" integer,
	"last_sync_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "suppliers" (
	"id" text PRIMARY KEY NOT NULL,
	"name" text NOT NULL,
	"adapter" text NOT NULL,
	"config" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"currency" text NOT NULL,
	"status" text DEFAULT 'active' NOT NULL,
	"auto_forward" boolean DEFAULT false NOT NULL,
	"last_sync_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "auth_sessions" ADD CONSTRAINT "auth_sessions_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "oauth_accounts" ADD CONSTRAINT "oauth_accounts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cart_lines" ADD CONSTRAINT "cart_lines_cart_id_carts_id_fk" FOREIGN KEY ("cart_id") REFERENCES "public"."carts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "cart_lines" ADD CONSTRAINT "cart_lines_variant_id_product_variants_id_fk" FOREIGN KEY ("variant_id") REFERENCES "public"."product_variants"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "carts" ADD CONSTRAINT "carts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_collection_items" ADD CONSTRAINT "product_collection_items_collection_id_product_collections_id_fk" FOREIGN KEY ("collection_id") REFERENCES "public"."product_collections"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_collection_items" ADD CONSTRAINT "product_collection_items_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_category_links" ADD CONSTRAINT "product_category_links_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_category_links" ADD CONSTRAINT "product_category_links_category_id_product_categories_id_fk" FOREIGN KEY ("category_id") REFERENCES "public"."product_categories"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_media" ADD CONSTRAINT "product_media_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "product_variants" ADD CONSTRAINT "product_variants_product_id_products_id_fk" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "comments" ADD CONSTRAINT "comments_author_id_users_id_fk" FOREIGN KEY ("author_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "content_revisions" ADD CONSTRAINT "content_revisions_entry_id_content_entries_id_fk" FOREIGN KEY ("entry_id") REFERENCES "public"."content_entries"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "discount_redemptions" ADD CONSTRAINT "discount_redemptions_discount_id_discounts_id_fk" FOREIGN KEY ("discount_id") REFERENCES "public"."discounts"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "experiment_participants" ADD CONSTRAINT "experiment_participants_experiment_id_experiments_id_fk" FOREIGN KEY ("experiment_id") REFERENCES "public"."experiments"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_fulfillments" ADD CONSTRAINT "order_fulfillments_order_id_orders_id_fk" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_events" ADD CONSTRAINT "order_events_order_id_orders_id_fk" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_lines" ADD CONSTRAINT "order_lines_order_id_orders_id_fk" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "orders" ADD CONSTRAINT "orders_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE set null ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "order_refunds" ADD CONSTRAINT "order_refunds_order_id_orders_id_fk" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "price_history" ADD CONSTRAINT "price_history_variant_id_product_variants_id_fk" FOREIGN KEY ("variant_id") REFERENCES "public"."product_variants"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_role_id_roles_id_fk" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "review_meta" ADD CONSTRAINT "review_meta_comment_id_comments_id_fk" FOREIGN KEY ("comment_id") REFERENCES "public"."comments"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "shipping_rates" ADD CONSTRAINT "shipping_rates_zone_id_shipping_zones_id_fk" FOREIGN KEY ("zone_id") REFERENCES "public"."shipping_zones"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "supplier_orders" ADD CONSTRAINT "supplier_orders_supplier_id_suppliers_id_fk" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "supplier_products" ADD CONSTRAINT "supplier_products_variant_id_product_variants_id_fk" FOREIGN KEY ("variant_id") REFERENCES "public"."product_variants"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "supplier_products" ADD CONSTRAINT "supplier_products_supplier_id_suppliers_id_fk" FOREIGN KEY ("supplier_id") REFERENCES "public"."suppliers"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
CREATE INDEX "admin_audit_record_idx" ON "admin_audit" USING btree ("resource","record_id","created_at");--> statement-breakpoint
CREATE INDEX "admin_audit_user_idx" ON "admin_audit" USING btree ("user_id","created_at");--> statement-breakpoint
CREATE INDEX "rate_limits_expires_idx" ON "rate_limits" USING btree ("expires_at");--> statement-breakpoint
CREATE INDEX "auth_sessions_user_idx" ON "auth_sessions" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "oauth_accounts_user_idx" ON "oauth_accounts" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "carts_user_idx" ON "carts" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "carts_expires_idx" ON "carts" USING btree ("expires_at");--> statement-breakpoint
CREATE INDEX "product_category_links_cat_idx" ON "product_category_links" USING btree ("category_id");--> statement-breakpoint
CREATE INDEX "product_variants_product_idx" ON "product_variants" USING btree ("product_id","position");--> statement-breakpoint
CREATE INDEX "products_status_idx" ON "products" USING btree ("status","published_at");--> statement-breakpoint
CREATE UNIQUE INDEX "comment_bans_subject_idx" ON "comment_bans" USING btree ("subject");--> statement-breakpoint
CREATE INDEX "comments_entity_idx" ON "comments" USING btree ("entity_type","entity_id","status","created_at");--> statement-breakpoint
CREATE INDEX "comments_status_idx" ON "comments" USING btree ("status","created_at");--> statement-breakpoint
CREATE INDEX "comments_author_idx" ON "comments" USING btree ("author_id");--> statement-breakpoint
CREATE INDEX "consent_records_subject_idx" ON "consent_records" USING btree ("subject_id","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "content_entries_slug_idx" ON "content_entries" USING btree ("collection","slug","locale");--> statement-breakpoint
CREATE INDEX "content_entries_list_idx" ON "content_entries" USING btree ("collection","locale","status");--> statement-breakpoint
CREATE INDEX "content_entries_group_idx" ON "content_entries" USING btree ("group_id");--> statement-breakpoint
CREATE INDEX "content_revisions_entry_idx" ON "content_revisions" USING btree ("entry_id","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "discount_redemptions_order_idx" ON "discount_redemptions" USING btree ("discount_id","order_id");--> statement-breakpoint
CREATE INDEX "discount_redemptions_email_idx" ON "discount_redemptions" USING btree ("discount_id","email");--> statement-breakpoint
CREATE INDEX "experiment_participants_variant_idx" ON "experiment_participants" USING btree ("experiment_id","variant");--> statement-breakpoint
CREATE INDEX "form_submissions_form_idx" ON "form_submissions" USING btree ("form_key","created_at");--> statement-breakpoint
CREATE INDEX "jobs_due_idx" ON "jobs" USING btree ("status","run_at");--> statement-breakpoint
CREATE UNIQUE INDEX "jobs_dedupe_idx" ON "jobs" USING btree ("dedupe_key") WHERE "jobs"."dedupe_key" is not null and "jobs"."status" in ('queued', 'running');--> statement-breakpoint
CREATE INDEX "media_folder_idx" ON "media" USING btree ("folder","status");--> statement-breakpoint
CREATE INDEX "order_fulfillments_order_idx" ON "order_fulfillments" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "order_events_order_idx" ON "order_events" USING btree ("order_id","created_at");--> statement-breakpoint
CREATE INDEX "order_lines_order_idx" ON "order_lines" USING btree ("order_id");--> statement-breakpoint
CREATE INDEX "orders_user_idx" ON "orders" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "orders_status_idx" ON "orders" USING btree ("status","created_at");--> statement-breakpoint
CREATE INDEX "orders_email_idx" ON "orders" USING btree ("email");--> statement-breakpoint
CREATE INDEX "price_history_variant_idx" ON "price_history" USING btree ("variant_id","valid_from");--> statement-breakpoint
CREATE INDEX "user_roles_role_idx" ON "user_roles" USING btree ("role_id");--> statement-breakpoint
CREATE INDEX "search_documents_tsv_idx" ON "search_documents" USING gin ("tsv");--> statement-breakpoint
CREATE INDEX "search_documents_locale_idx" ON "search_documents" USING btree ("locale","type");--> statement-breakpoint
CREATE INDEX "shipping_rates_zone_idx" ON "shipping_rates" USING btree ("zone_id");--> statement-breakpoint
CREATE INDEX "supplier_exceptions_status_idx" ON "supplier_exceptions" USING btree ("status","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "supplier_orders_order_idx" ON "supplier_orders" USING btree ("order_id","supplier_id");--> statement-breakpoint
CREATE INDEX "supplier_orders_status_idx" ON "supplier_orders" USING btree ("status");--> statement-breakpoint
CREATE INDEX "supplier_products_supplier_idx" ON "supplier_products" USING btree ("supplier_id","external_variant_id");