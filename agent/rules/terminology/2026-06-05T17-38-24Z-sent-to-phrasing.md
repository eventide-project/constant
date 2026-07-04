# "sent to" phrasing for method/initializer inputs

When describing a value that is passed into a method or an initializer — in TestBench test descriptions and in prose generally — phrase it as the value being **sent to** that method/initializer. For example: "Value is the constant object **sent to the initializer**", not "...the instance was initialized with" or "...passed to the initializer".

**Why:** "Sent to" is the messaging vocabulary the user works in (Eventide ecosystem); it frames a call as sending a message with arguments. The user corrected "initialized with" → "sent to the initializer" directly.

**How to apply:** In `test "..."` descriptions and similar prose, say a value is "sent to" the method/initializer that receives it. Related: the `control_` test-variable prefix rule.
