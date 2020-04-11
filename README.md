# Ascension

Ascension is a small project which handles audiobooks. The core features of Ascension is keeping track of a list of books, and for each book a list of audio files. For each audio file the current listening progress can be stored, which means that you can listen to longer files without losing track of where you are.

This is a backend for Ascension written in Elixir using the Phoenix web framework. It primarily consists of a JSON REST API which allows the creation of users, authentication and managing of books. I have implemented two different frontends for Ascension, one in [Vue](https://github.com/thehellbean/ascension-frontend-vue) and one using [React/Redux](https://github.com/thehellbean/ascension-frontend-react)
