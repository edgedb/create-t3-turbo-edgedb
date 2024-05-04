import { auth } from ".";

const { signout, magicLinkSignIn, magicLinkSignUp } =
  auth.createServerActions();

export { signout, magicLinkSignIn, magicLinkSignUp };