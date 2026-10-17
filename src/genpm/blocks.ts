// Bloques disponibles en las páginas. Los kits y el proyecto añaden los suyos a la lista.
import { countdown } from '@/app/(landing)/_blocks/countdown'; // kit-landing
import { buyNow, productGrid } from '@/app/(store)/_blocks/products'; // kit-store
import { coreBlocks, createBlockRegistry } from '@/lib/blocks';

export const blocks = createBlockRegistry([
  ...coreBlocks,
  countdown, // kit-landing
  productGrid, // kit-store
  buyNow, // kit-store
]);
