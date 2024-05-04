using extension auth;

module default {
  single global current_user := (
    assert_single((
      select User
      filter global ext::auth::ClientTokenIdentity in .identities
    ))
  );

  type User extending Auditable {
    displayName: str;
    multi identities: ext::auth::Identity {
      constraint exclusive;
    };

    access policy only_self_can_update
      allow update, delete
      using (global current_user.id ?= .id);

    access policy anyone_can_insert_or_select
      allow select, insert;
  };

  type Post extending Auditable {
    required title: str;
    required content: str;

    required author: User;

    access policy author_has_full_access
      allow all
      using (global current_user ?= .author);

    access policy anyone_can_insert_or_select
      allow select, insert;
  };

  abstract type Auditable {
    required createdAt: datetime {
      default := datetime_of_statement();
      rewrite insert using (datetime_of_statement());
    };

    required updatedAt: datetime {
      default := datetime_of_statement();
      rewrite update using (datetime_of_statement());
    };

    deletedAt: datetime;

    access policy hide_deleted
      deny select
      using (exists .deletedAt);
  };
}
