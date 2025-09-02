import urllib.request
import urllib.parse
import json
from collections import defaultdict, OrderedDict

BASIC_ORDER = ["plains", "island", "swamp", "mountain", "forest"]

def basic_type(card_name: str):
    n = card_name.lower()
    for t in BASIC_ORDER:
        if t in n:
            return t
    return None

def fetch_all(url: str):
    all_cards = []
    while url:
        with urllib.request.urlopen(url) as resp:
            data = json.load(resp)
        all_cards.extend(data["data"])
        url = data.get("next_page") if data.get("has_more") else None
    return all_cards

def image_url(card: dict):
    if "image_uris" in card and card["image_uris"]:
        return card["image_uris"].get("large") or card["image_uris"].get("normal")
    if card.get("card_faces"):
        faces = card["card_faces"]
        if faces and faces[0].get("image_uris"):
            return faces[0]["image_uris"].get("large") or faces[0]["image_uris"].get("normal")
    return None

def build_groups(cards):
    per_set = defaultdict(lambda: defaultdict(list))
    for c in cards:
        t = basic_type(c.get("name", ""))
        if not t:
            continue
        set_code = c.get("set", "").upper()
        url = image_url(c)
        if not url:
            continue
        url = url.split("?", 1)[0]
        cn = c.get("collector_number", "")
        # keep both number + url
        per_set[set_code][t].append((cn, url))

    groups_out = OrderedDict()
    leftovers = OrderedDict()

    for set_code, type_buckets in sorted(per_set.items()):
        # sort each type bucket by collector number
        for t in BASIC_ORDER:
            type_buckets[t].sort(key=lambda x: (int(x[0]) if x[0].isdigit() else float("inf"), x[0]))

        group_index = 1
        while any(type_buckets[t] for t in BASIC_ORDER):
            group_name = set_code if group_index == 1 else f"{set_code}{group_index}"
            group_lands = {}
            for t in BASIC_ORDER:
                if type_buckets[t]:
                    cn, url = type_buckets[t].pop(0)
                    group_lands[t] = (cn, url)
            if len(group_lands) < 5:
                leftovers[group_name] = group_lands
            else:
                groups_out[group_name] = group_lands
            group_index += 1

    return groups_out, leftovers

def main():
    query = "(type:land type:basic) is:fullart"
    params = {"q": query, "unique": "prints", "order": "set"}
    SCRYFALL_URL = "https://api.scryfall.com/cards/search?" + urllib.parse.urlencode(params)

    cards = fetch_all(SCRYFALL_URL)
    groups, leftovers = build_groups(cards)

    print("local landImages = {")
    for group, lands in groups.items():
        print(f"    {group} = {{")
        for t in BASIC_ORDER:
            if t in lands:
                cn, url = lands[t]
                print(f'        {t} = "{url}", -- {cn}')
        print("    },")
    if leftovers:
        print("    -- leftovers (less than 5 types)")
        for group, lands in leftovers.items():
            print(f"    {group} = {{")
            for t in BASIC_ORDER:
                if t in lands:
                    cn, url = lands[t]
                    print(f'        {t} = "{url}", -- {cn}')
            print("    },")
    print("}")

if __name__ == "__main__":
    main()