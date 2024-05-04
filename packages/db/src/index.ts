import { createClient } from "edgedb";

export { default as e } from "../dbschema/edgeql-js";

export const client = createClient();