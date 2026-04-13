import { Browser } from "./browsers";
import handlers from "./handlers";
import rewrite from "./rewrite";
import type { FinickyConfig } from "/Applications/Finicky.app/Contents/Resources/finicky.d.ts";

export default {
  defaultBrowser: Browser.GoogleChrome,

  options: {
    logRequests: false,
    checkForUpdates: true,
    keepRunning: false,
    hideIcon: true,
  },

  rewrite,
  handlers,
} satisfies FinickyConfig;
