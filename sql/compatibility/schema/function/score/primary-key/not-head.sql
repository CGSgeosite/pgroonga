CREATE TABLE memos (
  content text,
  id int PRIMARY KEY
);

CREATE INDEX pgroonga_index ON memos
  USING pgroonga (id pgroonga.int4_ops,
                  content pgroonga.text_full_text_search_ops);

INSERT INTO memos (id, content) VALUES (1, 'PostgreSQL is a RDBMS.');
INSERT INTO memos (id, content) VALUES (2, 'Groonga is fast full text search engine.');
INSERT INTO memos (id, content) VALUES (3, 'PGroonga is a PostgreSQL extension that uses Groonga.');

SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = off;

SELECT id, content, pgroonga.score(memos)
  FROM memos
 WHERE content &@~ 'PGroonga OR Groonga';

DROP TABLE memos;
