import { UrlRewriteRule } from "/Applications/Finicky.app/Contents/Resources/finicky";

export default [
  {
    // Remove all marketing/tracking information from urls

    match: () => true,
    url: (url: URL) => {
      const removeKeysStartingWith = ["utm_", "uta_"];
      const removeKeys = ["fbclid", "gclid"];

      for (const key of [...url.searchParams.keys()]) {
        if (
          removeKeysStartingWith.some((prefix) => key.startsWith(prefix)) ||
          removeKeys.includes(key)
        ) {
          url.searchParams.delete(key);
        }
      }

      return url.href;
    },
  },
] satisfies UrlRewriteRule[];
