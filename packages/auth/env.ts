/* eslint-disable no-restricted-properties */
import { createEnv } from "@t3-oss/env-nextjs";

export const env = createEnv({
  server: {},
  client: {},
  experimental__runtimeEnv: {},
  skipValidation: !!process.env.CI || !!process.env.SKIP_ENV_VALIDATION,
});
