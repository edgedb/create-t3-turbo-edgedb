import type { TRPCRouterRecord } from "@trpc/server";
import { z } from "zod";

import { e } from "@acme/db";
import { CreatePostSchema } from "@acme/validators";

import { protectedProcedure, publicProcedure } from "../trpc";

export const postRouter = {
  all: publicProcedure.query(({ ctx }) => {
    const query = e.select(e.Post, (p) => ({
      ...p["*"],
      order_by: {
        expression: p.id,
        direction: "DESC",
      },
      limit: 10,
    }));

    return query.run(ctx.session.client);
  }),

  byId: publicProcedure
    .input(z.object({ id: z.string() }))
    .query(({ ctx, input }) => {
      const query = e.select(e.cast(e.Post, e.uuid(input.id)));

      return query.run(ctx.session.client);
    }),

  create: protectedProcedure
    .input(CreatePostSchema)
    .mutation(({ ctx, input }) => {
      const query = e.insert(e.Post, {
        title: input.title,
        content: input.content,
        author: e.assert_exists(
          e.select(e.User, () => ({
            filter_single: { id: e.assert_exists(e.global.current_user).id },
          })),
        ),
      });

      return query.run(ctx.session.client);
    }),

  delete: protectedProcedure
    .input(z.object({ id: z.string() }))
    .mutation(({ ctx, input }) => {
      const query = e.update(e.Post, () => ({
        filter_single: { id: e.uuid(input.id) },
        set: {
          deletedAt: e.datetime_of_statement(),
        }
      }));

      return query.run(ctx.session.client);
    }),
} satisfies TRPCRouterRecord;
