#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <X11/Xlib.h>
#include <X11/XKBlib.h>

int main() {
  Display *dpy = XOpenDisplay(NULL);

  if (!dpy) {
    fprintf(stderr, "Can't open display\n");
    exit(EXIT_FAILURE);
  }

  XkbStateRec state = {0};
  int32_t status = XkbGetState(dpy, XkbUseCoreKbd, &state);

  if (status != 0) {
    fprintf(stderr, "XkbGetState Failed: %d\n", status);
    exit(EXIT_FAILURE);
  }

  if (state.group < 0 || state.group > 1) {
    fprintf(stderr, "Unexpected keyboard group index: %d\n", state.group);
  }

  const char *groups[] = {
    "us",
    "us(intl)",
  };

  fprintf(stdout, groups[state.group]);

  return 0;
}
