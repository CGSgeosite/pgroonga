CREATE TABLE memos (
  title text,
  content text
);

INSERT INTO memos VALUES ('hyphen', '090-1234-5678');
INSERT INTO memos VALUES ('parenthesis', '(090)1234-5678');

CREATE INDEX pgrn_index ON memos
 USING pgroonga ((ARRAY[title, content])
                 pgroonga_text_array_full_text_search_ops_v2)
  WITH (tokenizer = 'TokenNgram("loose_symbol", true)');

SET enable_seqscan = off;
SET enable_indexscan = on;
SET enable_bitmapscan = off;

EXPLAIN (COSTS OFF)
SELECT content, pgroonga_score(tableoid, ctid)
  FROM memos
 WHERE ARRAY[title, content] &@
       ('090-12345678',
        ARRAY[5, 2],
        'pgrn_index')::pgroonga_full_text_search_condition;

SELECT content, pgroonga_score(tableoid, ctid)
  FROM memos
 WHERE ARRAY[title, content] &@
       ('090-12345678',
        ARRAY[5, 2],
        'pgrn_index')::pgroonga_full_text_search_condition;

DROP TABLE memos;
