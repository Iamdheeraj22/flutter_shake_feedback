## 1.0.0

* **Initial Release:** Complete rewrite of the core engine to support advanced multi-shake sequence detection using `sensors_plus`.
* **Robust Shake Detection:** Implements minimum rapid movement counts, slop times, and cooldowns natively within the repository layer to prevent false positives and accidental triggers.
* **Clean Architecture:** Built from the ground up using a strict Clean Architecture layout (Data, Domain, Presentation).
* **State Management:** Fully integrated `flutter_bloc` (Cubit) to handle state propagation natively.
* **Customizability:** Allows developers to easily configure `ShakeSensitivity` (`low`, `medium`, `high`) and custom cooldown durations natively through the UI wrapper.
