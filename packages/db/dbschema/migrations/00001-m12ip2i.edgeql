CREATE MIGRATION m12ip2id55hppvaw5djl275y5fncd3u77nfbzxneluqbga6byihffa
    ONTO initial
{
  CREATE EXTENSION pgcrypto VERSION '1.3';
  CREATE EXTENSION auth VERSION '1.0';
  CREATE TYPE default::User {
      CREATE MULTI LINK identities: ext::auth::Identity {
          CREATE CONSTRAINT std::exclusive;
      };
      CREATE PROPERTY displayName: std::str;
  };
  CREATE SINGLE GLOBAL default::current_user := (std::assert_single((SELECT
      default::User
  FILTER
      (GLOBAL ext::auth::ClientTokenIdentity IN .identities)
  )));
};
