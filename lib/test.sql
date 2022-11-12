CREATE TABLE LocalAnime(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL ,
      imageUrl TEXT NOT NULL,
      url TEXT NOT NULL UNIQUE,
      type TEXT NOT NULL,
      releasedYear TEXT NOT NULL
      )