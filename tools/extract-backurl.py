import json
import sys

def extract_backurls(obj, urls=None):
    """
    Recursively extract BackURL with parent Transform positions.
    """
    if urls is None:
        urls = []

    if isinstance(obj, dict):
        # Check if this dict has both CustomDeck and Transform
        if "CustomDeck" in obj and "Transform" in obj:
            transform = obj["Transform"]
            posX = transform.get("posX", 0)
            posZ = transform.get("posZ", 0)

            # Round to nearest number for sorting
            posX_sort = round(posX)
            posZ_sort = round(posZ)

            for deck in obj["CustomDeck"].values():
                back_url = deck.get("BackURL")
                if back_url:
                    urls.append({
                        "url": back_url,
                        "posX": posX,
                        "posZ": posZ,
                        "posX_sort": posX_sort,
                        "posZ_sort": posZ_sort
                    })

        # Recurse through all values
        for v in obj.values():
            extract_backurls(v, urls)

    elif isinstance(obj, list):
        for item in obj:
            extract_backurls(item, urls)

    return urls

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <json_file> [--debug]")
        sys.exit(1)

    json_file = sys.argv[1]
    debug = "--debug" in sys.argv

    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    backurls_with_pos = extract_backurls(data)

    # Remove duplicates while keeping order
    seen = set()
    unique_urls = []
    for item in backurls_with_pos:
        if item["url"] not in seen:
            seen.add(item["url"])
            unique_urls.append(item)

    # Sort: top-to-bottom (Z descending), left-to-right (X ascending) using rounded even numbers
    unique_urls.sort(key=lambda x: (-x["posZ_sort"], x["posX_sort"]))

    # Print output
    for item in unique_urls:
        if debug:
            print(f"{item['url']}  |  posX: {item['posX']}, posZ: {item['posZ']} (rounded: X={item['posX_sort']}, Z={item['posZ_sort']})")
        else:
            print(f"\"{item['url']}\",")

if __name__ == "__main__":
    main()
