CREATE MIGRATION m1rrzqxucybod2ytp5gilajnl4glwbjo226ghv4rb2hqkvv7i6j3da
    ONTO m12ip2id55hppvaw5djl275y5fncd3u77nfbzxneluqbga6byihffa
{
  CREATE ABSTRACT TYPE default::Auditable {
      CREATE PROPERTY deletedAt: std::datetime;
      CREATE ACCESS POLICY hide_deleted
          DENY ALL USING (EXISTS (.deletedAt));
      CREATE REQUIRED PROPERTY createdAt: std::datetime {
          SET default := (std::datetime_of_statement());
          CREATE REWRITE
              INSERT 
              USING (std::datetime_of_statement());
      };
      CREATE REQUIRED PROPERTY updatedAt: std::datetime {
          SET default := (std::datetime_of_statement());
          CREATE REWRITE
              UPDATE 
              USING (std::datetime_of_statement());
      };
  };
  ALTER TYPE default::User EXTENDING default::Auditable LAST;
  CREATE TYPE default::Post EXTENDING default::Auditable {
      CREATE ACCESS POLICY anyone_can_insert_or_select
          ALLOW SELECT, INSERT ;
      CREATE REQUIRED LINK author: default::User;
      CREATE REQUIRED PROPERTY content: std::str;
      CREATE REQUIRED PROPERTY title: std::str;
  };
  ALTER TYPE default::Post {
      CREATE ACCESS POLICY author_has_full_access
          ALLOW ALL USING ((GLOBAL default::current_user ?= .author));
  };
};
