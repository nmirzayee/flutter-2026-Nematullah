# Practice 9 — NOTES

## Level 1: Lifted state

- `Shell` owns `_cart` above `MaterialApp`.
- `BooksScreen` receives `cart` and `onAdd`; `CartScreen` receives `items` and `onRemove`.
- `CartBadge` receives `count`.
- Adding `total` to the badge changes **2 constructors** (`BooksScreen`, `CartBadge`) and **3 files** (`main.dart`, `books_screen.dart`, `cart_badge.dart`), if `Shell` computes and forwards the total.
- Level 1 console row/build count: **TO MEASURE** on your device; `ListView.builder` only builds visible rows, so the count depends on viewport.

## Level 2: Model without widgets

- Two books added, first duplicate rejected, first removed: `1 items, 3100 ₸`.
- Attempting `cart.items.add(books[0])` throws `Unsupported operation: Cannot add to an unmodifiable list`.
- `Cart` has no `BuildContext` or UI dependency.

## Level 3: Provider mistakes (temporary experiments; revert them)

- `context.watch<Cart>().add(b)` inside an `onPressed` callback: provider reports an attempt to listen outside the widget tree/build context, commonly beginning `Tried to listen to a value exposed with provider, from outside of the widget tree`. **Paste your exact console message here after reproducing:** TO CAPTURE.
- `context.read<Cart>().count` in the badge's `build`: no exception; count stays stale because `read` does not subscribe. **Exact console output:** none.

## Level 4: Rebuild measurements

- With `watch` in `CartBadge`, 3 quantity increments: **expected 3 badge rebuilds**, measured: TO MEASURE.
- With `select` in `CartBadge`, 3 quantity increments: **expected 0 badge rebuilds**, measured: TO MEASURE.
- With `select`, removing a distinct book: **expected 1 badge rebuild**, measured: TO MEASURE.
- Track actual builds in DevTools > Performance > Track widget builds; keep `debugPrint('badge build')` for console evidence.

## Level 5: Where does it live?

- **Cart — provided:** both routes share it; it needs to outlive either screen.
- **Search text — ephemeral:** only the Books screen uses it; keep it in that screen's local State.
- **Total expanded/collapsed — ephemeral:** only the Cart screen's presentation needs this local toggle (if implemented).
- **Theme mode — lifted:** if a dark-mode switch existed, place the state above `MaterialApp`, because the whole app uses it; it could also be provided if shared across many widgets.

## Final checks

- [ ] Commit Level 1 as `lifted` before switching to Provider.
- [ ] Run `flutter pub get`, `dart format .`, `flutter analyze`, `flutter test`, `flutter run`.
- [ ] Fill in measured counts and the exact provider exception from your own run.
- [ ] Save and commit `screenshot_books.png` (two added, badge 2).
- [ ] Save and commit `screenshot_cart.png` (one book quantity 2 and total).
