# How to use

1. Message @PushMoreBot in Telegram or add it to a group.

2. Send `/start` to get your WEBHOOK URL.

3. The last part in the URL is your key.

4. `PushMore.new("hello world", key: "your-key").deliver

or

5. Set PUSH_MORE_KEY as ENV variable

6. PushMore.new("hello world").deliver # will use ENV["PUSH_MORE_KEY"]
