CREATE TABLE IF NOT EXISTS subscriber (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  created INTEGER DEFAULT (strftime('%s', 'now'))
);
