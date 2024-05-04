import { auth } from "@acme/auth";
import {
  magicLinkSignIn,
  magicLinkSignUp,
  signout,
} from "@acme/auth/actions";
import { Button } from "@acme/ui/button";
import { Input } from "@acme/ui/input";

export async function AuthShowcase() {
  const session = auth.getSession();
  if (!(await session.isSignedIn())) {
    return (
      <form>
        <Input type="email" placeholder="Email" name="email" id="email" />
        <Button
          size="lg"
          formAction={async (fd: FormData) => {
            "use server";
            const email = fd.get("email") as string;
            await magicLinkSignIn({ email });
          }}
        >
          Sign in
        </Button>
        <Button
          size="lg"
          formAction={async (fd: FormData) => {
            "use server";
            const email = fd.get("email") as string;
            await magicLinkSignUp({ email });
          }}
        >
          Sign up
        </Button>
      </form>
    );
  }

  const user = await session.client.queryRequiredSingle<{
    displayName: string | null;
  }>("select assert_exists((global current_user)) { displayName }");

  return (
    <div className="flex flex-col items-center justify-center gap-4">
      <p className="text-center text-2xl">
        <span>Logged in as {user.displayName ?? "Anonymous"}</span>
      </p>

      <form>
        <Button
          size="lg"
          formAction={async () => {
            "use server";
            await signout();
          }}
        >
          Sign out
        </Button>
      </form>
    </div>
  );
}
