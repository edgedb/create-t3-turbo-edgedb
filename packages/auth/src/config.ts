import { NextAuthOptions } from "@edgedb/auth-nextjs/app";

export const config: NextAuthOptions = {
  baseUrl: "http://localhost:3000",
  magicLinkFailurePath: "/error",
};