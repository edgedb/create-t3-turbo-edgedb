import { redirect } from "next/navigation";
import createAuth, { NextAuthSession } from "@edgedb/auth-nextjs/app";

import { client } from "@acme/db";

import { config } from "./config";

export const auth = createAuth(client, config);

export const { GET, POST } = auth.createAuthRouteHandlers({
  onMagicLinkCallback: async (params) => {
    if (params.isSignUp) {
      await client.query(
        `
        with identity := (
          select ext::auth::Identity filter .id = <uuid>$identityId
        ),
        insert User {
          identities := identity,
        };
      `,
        { identityId: params.tokenData.identity_id },
      );
    }

    redirect("/");
  },
});

export { NextAuthSession };
