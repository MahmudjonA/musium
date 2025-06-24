# 🎵 Musium – Flutter Audio Streaming App

**Musium** — это современное мобильное приложение для потокового воспроизведения аудио, разработанное на Flutter. Проект ориентирован на красивый пользовательский интерфейс, поддержку метаданных, Supabase-бэкенд и управление состоянием через `flutter_bloc`.

🎨 UI вдохновлён: [Figma дизайн](https://www.figma.com/design/WmYVCEvZmE4wMT506ehbuH/Musium?node-id=0-1&p=f&t=EoC3Oi6htSKEHv41-0)  
📦 Исходный код: [GitHub – musium](https://github.com/MahmudjonA/musium.git)

---

## 🚀 Основные возможности

- 🎧 Воспроизведение аудиофайлов через `just_audio`
- 🏷 Извлечение метаданных MP3 (`audio_metadata_reader`)
- 🖼 Отображение обложек треков
- 🗂 Загрузка файлов с устройства
- 📤 Загрузка аудио и изображений в Supabase Storage
- 🧾 Хранение URL и данных в Supabase DB
- 🎛 Аудиосессия с `audio_session`
- ⚙ Управление зависимостями с `get_it`
- 📦 Хранение данных оффлайн через `hive_flutter`
- 📡 Подключение к API через `dio`

---

## 🛠 Используемый стек

| Категория         | Пакеты/инструменты                      |
|------------------|-----------------------------------------|
| Язык             | Dart                                    |
| Фреймворк        | Flutter                                 |
| UI/UX            | Figma                                   |
| Управление сост. | flutter_bloc                            |
| Backend          | Supabase (auth, storage, database)      |
| HTTP-клиент      | dio + logger                            |
| Аудио            | just_audio, audio_session               |
| Загрузка файлов  | file_picker, audio_metadata_reader      |
| Локальное хранилище | hive_flutter                         |

---

## 📂 Структура проекта

```bash
lib/
├── core/           # Константы, утилиты, базовые настройки
├── features/       # Модули приложения (upload, player и т.д.)
├── data/           # Источники данных, модели, репозитории
├── presentation/   # UI-экраны и виджеты
└── main.dart       # Точка входа
````

---

## 📱 Установка и запуск

```bash
git clone https://github.com/MahmudjonA/musium.git
cd musium
flutter pub get
flutter run
```

---

## 📦 Основные зависимости

* `flutter_bloc` — управление состоянием
* `just_audio`, `audio_session` — воспроизведение аудио
* `audio_metadata_reader` — метаданные MP3
* `file_picker` — выбор файлов из памяти
* `supabase_flutter` — аутентификация, storage и база данных
* `dio` — http-запросы
* `hive_flutter` — кэш и локальное хранилище
* `flutter_spinkit` — индикаторы загрузки
* `logger` — логгирование

---

## 🖼 Активы и ресурсы

* 📁 `assets/images/` — изображения (обложки треков и UI)
* 🎨 Шрифт — используйте при необходимости

---

## 🧪 Тестирование

Для запуска тестов:

```bash
flutter test
```

---

## 🔐 Аутентификация

* Supabase использует email/password или анонимную авторизацию
* Настроено безопасное подключение к Storage и Database

---

## 📜 Лицензия

Этот проект открыт для изучения и разработки. Вы можете использовать его как основу для своего собственного музыкального приложения.

---

> Разработано с ❤️ в Узбекистане — [Mahmudjon Abdumuratov](https://github.com/MahmudjonA)
