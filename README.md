Patch:

```
diff --git a/scripts/mk_util.py b/scripts/mk_util.py
index 6372e87fc..13cf8a894 100644
--- a/scripts/mk_util.py
+++ b/scripts/mk_util.py
@@ -293,6 +293,8 @@ def test_fpmath(cc):
global FPMATH_FLAGS
if is_verbose():
print("Testing floating point support...")
+    FPMATH_FLAGS=""
+    return "UNKNOWN"
t = TempFile('tstsse.cpp')
t.add('int main() { return 42; }\n')
t.commit()
diff --git a/src/util/debug.cpp b/src/util/debug.cpp
index 4434cb19f..975656e83 100644
--- a/src/util/debug.cpp
+++ b/src/util/debug.cpp
@@ -97,7 +97,7 @@ void invoke_gdb() {
case 'g':
sprintf(buffer, "gdb -nw /proc/%d/exe %d", getpid(), getpid());
std::cerr << "invoking GDB...\n";
-            if (system(buffer) == 0) {
+            if (1 /*system(buffer)*/ == 0) {
std::cerr << "continuing the execution...\n";
}
else {
diff --git a/src/util/mpz.cpp b/src/util/mpz.cpp
index 32a074eb3..bfc65f8dd 100644
--- a/src/util/mpz.cpp
+++ b/src/util/mpz.cpp
@@ -30,7 +30,7 @@ Revision History:
#else
#error No multi-precision library selected.
#endif
-#include <immintrin.h> 
+//#include <immintrin.h> 

// Available GCD algorithms
// #define EUCLID_GCD
```

Compiling Z3 for iOS:

    env CPPFLAGS="-arch arm64 -mios-version-min=12.0 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS12.1.sdk" python scripts/mk_make.py


