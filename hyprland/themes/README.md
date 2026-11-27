# Темы рабочего окружения: палитра AncientAliens

Все цвета берутся из одной палитры: `~/.config/noctalia/palettes/AncientAliens.json`
(холодная стальная синева по мотивам темы AncientAliens из галереи HyDE).

| Цвет | hex | Где |
|---|---|---|
| Фон | `#09111c` | панель Noctalia, окна GTK/Qt, терминал, редактор (один цвет везде) |
| Карточки | `#13202d` | карточки Noctalia, кнопки и карточки GTK/Qt, подсказки |
| Заголовки | `#070f19` | заголовки окон, чуть темнее фона |
| Рамки | `#2d485b` | разделители, неактивные рамки |
| Текст | `#d6e6f2` | везде |
| Акцент | `#aad5f0` | GTK, Noctalia, рамки Hyprland |
| Акцент Qt | `#6fa6cc` / `#3e6f92` | галочки и выделение в Kvantum/KDE (под белый текст) |

## Что откуда

| Что | Источник | Как пересобрать |
|---|---|---|
| Noctalia + ghostty | `~/.config/noctalia/palettes/AncientAliens.json` | подхватывается сама при сохранении |
| GTK 3/4 + libadwaita | `Colloid-gtk-theme/src/sass/_color-palette-aliens.scss` | `cd Colloid-gtk-theme && ./install.sh -c dark -l --tweaks aliens` |
| Kvantum (Qt) | `kvantum-aliens/recolor.py` (из `Colloid-kde/Kvantum/Colloid`) | `python3 kvantum-aliens/recolor.py` |
| Цвета KDE (Dolphin, Kate) | `kvantum-aliens/make-colors.py` | `python3 kvantum-aliens/make-colors.py`, затем влить в `~/.config/kdeglobals` |
| Подсветка в Kate | `~/.local/share/org.kde.syntax-highlighting/themes/AncientAliens.theme` | правится руками |
| Рамки и тень Hyprland | `~/.config/hypr/appearance/{general,decoration}.lua` | `hyprctl reload` |
| Окна самого Hyprland | `~/.config/hypr/hyprtoolkit.conf` | перезапуск окна |

## Правки в исходниках Colloid

В `Colloid-gtk-theme` добавлена схема `aliens`:
- `install.sh`: `-Aliens` в `SCHEME_VARIANTS` и ветки `aliens)` / `-Aliens)`;
- `src/sass/_color-palette-aliens.scss`: палитра;
- `src/main/labwc/themerc*-Aliens`, `src/main/plank/theme-*-Aliens`, `src/assets/gtk-2.0/assets*-Aliens`: копии стандартных файлов, без них установщик падает.

`git -C Colloid-gtk-theme status` покажет все изменения.

## Откат

Catppuccin: `~/.config/theme-backup-catppuccin-20261126/RESTORE.md`.
Стандартный Colloid Dark: `gtk-theme-name=Colloid-Dark`, Kvantum `ColloidDark`, схема KDE `ColloidDark`.

## Waybar (панель вместо бара noctalia, 2026-11-27)

- Бар noctalia выключен: `[bar.default] enabled = false` в `~/.config/noctalia/config.toml`. Остальное в noctalia работает: уведомления, OSD, лаунчер, Control Center, локскрин.
- Waybar запускается из `~/.config/hypr/autostart.lua`. Конфиг лежит в `~/.config/waybar/`: `config.jsonc` и `style.css` с цветами AncientAliens через `@define-color`.
- Кнопки открывают окна noctalia по IPC: `noctalia msg panel-toggle launcher|clipboard|session|control-center [tab]`.
- Модуль `custom/ryzen` убран с панели, пресеты переключаются плиткой в Control Center. Его описание и `scripts/ryzen-profile.sh` остались, вернуть можно, добавив `"custom/ryzen"` в `modules-right`. `scripts/notifications.sh` показывает колокольчик с состоянием DND (signal 9).
- Иконки Nerd Font бери только из диапазона Material Design (U+F0000+). Символы из BMP PUA (U+E000–F8FF) вырезаются при записи через heredoc.
- Откат: удалить `enabled = false` в noctalia и строку waybar в autostart.lua. Бэкапы: `*.bak-waybar-*`.
- Темы waybar лежат в `~/.config/waybar/themes/`: `capsules`, `islands`, `pills` (активная), `mac`, `outline`, `underline`. Палитра для всех одна, в `themes/_palette.css`. В `style.css` только `@import` активной темы. Переключение: `~/.config/waybar/scripts/theme.sh <имя>`, без аргумента выводит список.

### Раскладки waybar (classic / aliens)

- `~/.config/waybar/config.jsonc` — симлинк на `layouts/<имя>.jsonc`. Переключение: `scripts/layout.sh <classic|aliens>`. Скрипт меняет конфиг и тему и перезапускает waybar. Autostart просто запускает `waybar`, поэтому поднимается та раскладка, которая выбрана.
- **classic**: исходный набор модулей, тема `pills`.
- **aliens** (своя): `layouts/aliens.jsonc` + `themes/aliens.css`. Конфиг сгенерирован python-скриптом, иконки заданы escape-кодами `\U000F....`.
  - Слева лаунчер (ПКМ открывает обои), рабочие столы с иконками окон (`window-rewrite`) и заголовок окна.
  - По центру mpris (управление через `noctalia msg media`) и блок «часы + погода». У часов календарь во всплывающей подсказке. Погода берётся из кэша noctalia `~/.cache/noctalia/weather.json`.
  - Справа CPU, при наведении выезжают RAM и температура. Дальше трей за стрелкой, переключатели noctalia (wifi, bt, caffeine, night, dnd), группа «раскладка, звук, яркость, батарея» и Control Center.
  - Мост к noctalia: `scripts/noctalia-bridge.py <модуль> [toggle]`, обновление по сигналу RTMIN+10. У caffeine нет геттера в noctalia, поэтому его состояние хранится в файле `$XDG_RUNTIME_DIR/waybar-caffeine`.
  - Колесо на звуке и яркости вызывает `noctalia msg volume-*/brightness-*`, поэтому показывается OSD noctalia, а яркость меняется и на внешнем мониторе по DDC.
  - Размытие под островками задаёт правило Hyprland `~/.config/hypr/rules/layer_rules.lua` (`ignore_alpha = 0.2`).
- Отступы панели (margin 8) совпадают с `general:gaps_out = 8` Hyprland: края островков стоят вровень с рамками окон.
  - Оформление aliens: три полупрозрачных островка (левый, центральный, правый). Группы внутри островков разделены тонкой вертикальной чертой. Если увеличить вертикальный `margin` у групп больше 4px, они перестают помещаться в высоту панели 34px, и waybar выдаёт warning.
- **calm**: `layouts/calm.jsonc` + `themes/calm.css`, высота 30.
  - Рабочие столы показаны кружками, все 10 постоянные. Список нужно задавать явно: `{"1":[],…}`, потому что с `{"*":10}` кружки дублируются. Пустые бледные, занятые серые, активный вытянут в акцентную пилюлю.
  - По центру дата и время. Дата задаётся в `clock#date` форматом `{:L%A, %d %B}`, флаг `L` обязателен, иначе локаль ru_RU игнорируется. Время в формате AM/PM задаёт `custom/time` с `LC_TIME=C`: в ru_RU `%p` пустой, а локаль у clock-модулей общая. Музыки и погоды нет. Точка 󰂛 видна только при включённом DND.
  - Справа трей (без скрытия) и цветные иконки без чисел. Числа появляются только по порогам: CPU ≥70%, RAM ≥85%, температура ≥80°, батарея ≤30%. Bluetooth, caffeine и ночной свет видны только когда включены (`noctalia-bridge.py <x> quiet`).
  - Нюанс: если обернуть формат custom-модуля в `<span>`, waybar перестаёт прятать модуль с пустым текстом. Поэтому цвета таких модулей задаются через CSS.
- **one**: `layouts/one.jsonc` — это симлинк на `calm.jsonc`, модули те же. Тема `themes/one.css`: один общий островок на всю ширину (фон у `window#waybar`, радиус 15), у модулей нет своего фона и нет hover-эффектов.

## Панель: снова noctalia (2026-11-27)

- Waybar отключён: в autostart.lua строка закомментирована, его конфиги и раскладки лежат в `~/.config/waybar`. Вернуть: раскомментировать строку и поставить `[bar.default] enabled = false`.
- Бар noctalia в `config.toml` сделан одним плавающим островком: `margin_edge = 8`, `margin_ends = 8` (как `gaps_out`), `radius = 15`, `background_opacity = 0.72`, blur, `hover_highlight = false`.
- Виджеты разложены по `capsule_group` без фона (`opacity = 0`). Внутри группы интервал 10, между группами 20: sys (cpu, ram, temp), input (keyboard_layout, clipboard), hw (volume, brightness, battery), shell (notifications, control-center). Ryzen на панель не возвращал.
- Из state-файла `~/.local/state/noctalia/settings.toml` удалены `margin_edge`, `margin_ends`, `padding` и `radius` у `[bar.default]`: они перекрывали `config.toml`.
- Раскладка панели noctalia (обновлено):
  - Слева: launcher · workspaces (10 кружков без цифр; столы 1–10 постоянные, задаются в `~/.config/hypr/rules/workspace_rules.lua`) · [cpu, ram, temp, power] · active_window.
  - В центре: clock `{:%-I:%M %p}`.
  - Справа: tray · [clipboard, keyboard_layout] · [volume, battery, network] · [notifications, control-center].
  - Виджет power — свой плагин `~/.local/share/noctalia/plugins/power_draw`. Показывает PPT из hwmon `amdgpu` (CPU и iGPU вместе), если датчика нет — `BAT1/power_now`. Плагин включён через `noctalia msg plugins enable`: state-файл перекрывает `[plugins]` из `config.toml`.

## Панель: waybar «main» (2026-11-27, текущая)

- Бар noctalia снова выключен (`[bar.default] enabled = false`), waybar в autostart, раскладка `main` (`layouts/main.jsonc` + `themes/main.css`).
- Слева: launcher · 10 кружков · [CPU, RAM, temp, W] · заголовок окна. В центре: время `h:MM AM/PM` (`custom/time`, LC_TIME=C). Справа: tray · [clipboard, layout] · [volume, battery, network] · [notifications, control center].
- Сетка отступов: иконка → текст 7px (два пробела после span), внутри группы 8px, между группами 16px (плотная сетка; прежняя была 12/24) без разделителей (черты пробовали, убраны по просьбе; если вернуть — `border-left` у групп и `margin: 4px 0`, больший margin не влезает в 32px), край островка 12px. Иконки рисуются через `<span>` шрифтом CaskaydiaCove Nerd Font **Mono**: ширина у всех одинаковая, до текста ровно один пробел. Цифры табличные (`font-feature-settings: "tnum"`).
- `scripts/power.py` показывает **PPT FAST** из `/sys/kernel/ryzen_smu_drv/pm_table` (читается без root): это то значение, которое ограничивает `ryzenadj --fast-limit`. Float32 по индексам: 0 STAPM limit, 1 STAPM value, 2 FAST limit, 3 FAST value, 4 SLOW limit, 5 SLOW value. Hwmon amdgpu `power1_input` даёт мгновенные пики целыми ваттами (видел до 18–24 Вт при лимите 15), поэтому он только запасной вариант. STAPM limit прошивка HP держит около 21.5 Вт, но мощность всё равно ограничена PPT 15/15.
- `scripts/kb-layout.py` выводит US/RU и обновляется по событию `activelayout` из socket2 Hyprland. Встроенный `hyprland/language` в waybar 0.16 игнорирует `format-<lang>`.
- Колокольчик: `noctalia-bridge.py dnd`, иконка выбирается через `format-icons` по `alt` (on/off).
- Кружки: занятые `alpha(@fg, 0.75)`, пустые `alpha(@muted, 0.22)`, активный — акцентная пилюля. Сеть: иконка + текст (SSID / Ethernet / No IP / Offline / Wi-Fi off), `max-length` 20; без сети текст приглушён.
