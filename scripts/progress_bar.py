# Make sure to install the 'progress' package:
# pip install progress

try:
    from progress.bar import ChargingBar
    USE_PROGRESS_BAR = True
except ModuleNotFoundError:
    USE_PROGRESS_BAR = False
    print("Warning: 'progress' package not available. Using simple progress output.")

# progress bar to tell how far along the code is
# configurable title
class ProgressBar:
    def __init__(self, userInfo, total):
        # variable initialization
        self.userInfo = userInfo
        self.total = total
        self.current = 0

        if USE_PROGRESS_BAR:
            # create the bar at the start
            self.bar = ChargingBar(
                message=f"{userInfo} %(index)s/%(max)s",
                max=total,
                suffix="%(percent).1f%% (ETA %(eta)ds)",
            )
        else:
            print(f"{userInfo} Starting... (0/{total})")

    def continue_progress(self):
        if USE_PROGRESS_BAR:
            self.bar.next()
        else:
            self.current += 1
            print(f"\r{self.userInfo} Progress: {self.current}/{self.total}", end="")

    def end_progress(self):
        if USE_PROGRESS_BAR:
            self.bar.finish()
        else:
            print(f"\n{self.userInfo} Complete!")

    def set_message(self, item=None):
        if item is not None:
            if USE_PROGRESS_BAR:
                self.bar.message = f"{self.userInfo} {item} %(index)s/%(max)s"
            else:
                print(f"\n{self.userInfo} {item}")

    def set_suffix(self, item=None):
        if item is not None and USE_PROGRESS_BAR:
            self.bar.suffix = f"%(percent).1f%% (ETA %(eta)ds) {item}"
