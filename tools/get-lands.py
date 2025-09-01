import urllib.request
import json
import re
from collections import defaultdict, OrderedDict

query = "(type:land type:basic) is:fullart unique:prints"
params = {
    "q": query,
    "order": "set"
}

SCRYFALL_URL = "https://api.scryfall.com/cards/search?" + urllib.parse.urlencode(params)

BASIC_ORDER = ["plains", "island", "swamp", "mountain", "forest"]

def basic_type(card_name: str):
    n = card_name.lower()
    for t in BASIC_ORDER:
        if t in n:
            return t
    return None

_num_prefix_re = re.compile(r"^(\d+)")
def collector_sort_key(collector_number: str):
    """
    Scryfall collector numbers can be like '75', '75a', '130★', '001p', etc.
    Sort by numeric prefix, then by remaining suffix.
    """
    if not collector_number:
        return (0, "")
    m = _num_prefix_re.match(collector_number)
    if m:
        num = int(m.group(1))
        suffix = collector_number[len(m.group(1)):]
        return (num, suffix)
    return (0, collector_number)

def fetch_all(url: str):
    all_cards = []
    while url:
        with urllib.request.urlopen(url) as resp:
            data = json.load(resp)
        all_cards.extend(data["data"])
        url = data.get("next_page") if data.get("has_more") else None
    return all_cards

def image_url(card: dict):
    # Prefer large; fall back to normal if needed
    if "image_uris" in card and card["image_uris"]:
        return card["image_uris"].get("large") or card["image_uris"].get("normal")
    if card.get("card_faces"):
        faces = card["card_faces"]
        if faces and faces[0].get("image_uris"):
            return faces[0]["image_uris"].get("large") or faces[0]["image_uris"].get("normal")
    return None

def build_groups(cards):
    # sets_seen preserves overall set order as returned by Scryfall (order=set)
    sets_seen = OrderedDict()

    # Per-set, bucket by basic type
    per_set = defaultdict(lambda: {t: [] for t in BASIC_ORDER})

    for c in cards:
        t = basic_type(c.get("name", ""))
        if not t:
            continue
        set_code = c.get("set", "").upper()
        if not set_code:
            continue
        url = image_url(c)
        if not url:
            continue
        cn = c.get("collector_number", "") or ""
        per_set[set_code][t].append((cn, url))
        if set_code not in sets_seen:
            sets_seen[set_code] = True

    # Sort each type list by collector number
    for set_code, buckets in per_set.items():
        for t in BASIC_ORDER:
            buckets[t].sort(key=lambda x: collector_sort_key(x[0]))

    # Build cyclical groups: SET, SET2, SET3, ...
    groups_out = []  # list of dicts with fields type,url,group in final order
    for set_code in sets_seen.keys():
        buckets = per_set[set_code]
        # Number of cycles = max count among the five basics
        n_cycles = max(len(buckets[t]) for t in BASIC_ORDER) if buckets else 0
        if n_cycles == 0:
            continue
        for i in range(n_cycles):
            group_name = set_code if n_cycles == 1 else f"{set_code}{i+1}"
            for t in BASIC_ORDER:
                entries = buckets[t]
                if i < len(entries):
                    _, url = entries[i]
                    groups_out.append({
                        "type": t,
                        "url": url,
                        "group": group_name
                    })
                # If a type is missing for this cycle, we just skip it.
                # (Most full-art cycles have all five.)
    return groups_out

def main():
    cards = fetch_all(SCRYFALL_URL)
    grouped_list = build_groups(cards)

    print("local landImages = {")
    for e in grouped_list:
        print(f'    {{ type = "{e["type"]}", url = "{e["url"].split("?", 1)[0]}", group = "{e["group"]}" }},')
    print("}")

if __name__ == "__main__":
    main()
