CREATE MIGRATION m1hpy5yanzkjlzlgj6i5hrvmspu4hs6ymnop7fct2vcj2th4ph566q
    ONTO m1rrzqxucybod2ytp5gilajnl4glwbjo226ghv4rb2hqkvv7i6j3da
{
  ALTER TYPE default::Auditable {
      ALTER ACCESS POLICY hide_deleted DENY SELECT;
  };
  ALTER TYPE default::User {
      CREATE ACCESS POLICY anyone_can_insert_or_select
          ALLOW SELECT, INSERT ;
      CREATE ACCESS POLICY only_self_can_update
          ALLOW UPDATE, DELETE USING (((GLOBAL default::current_user).id ?= .id));
  };
};
