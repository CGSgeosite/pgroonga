CREATE TABLE memos (
  title text,
  tags varchar(1023)[]
);

INSERT INTO memos VALUES ('PostgreSQL', ARRAY['PostgreSQL']);
INSERT INTO memos VALUES ('Groonga', ARRAY['Groonga']);
INSERT INTO memos VALUES ('PGroonga', ARRAY['PostgreSQL', 'Groonga']);

CREATE INDEX pgroonga_memos_index ON memos USING pgroonga (tags);

SET enable_seqscan = off;
SET enable_indexscan = off;
SET enable_bitmapscan = on;

SELECT title, tags
  FROM memos
 WHERE tags %% 'Groonga';

DROP TABLE memos;
