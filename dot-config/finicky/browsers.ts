import { BrowserSpecification } from "/Applications/Finicky.app/Contents/Resources/finicky";

export enum Browser {
  GoogleChrome = "Google Chrome",
}

export const heidiChromeProfile: BrowserSpecification = {
  name: Browser.GoogleChrome,
  profile: "Heidi Health",
};

export const personalChromeProfile: BrowserSpecification = {
  name: Browser.GoogleChrome,
  profile: "William",
};
