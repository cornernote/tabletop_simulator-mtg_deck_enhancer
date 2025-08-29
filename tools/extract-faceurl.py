import json
import sys

# Labels in fixed order
labels = ["plains", "island", "swamp", "mountain", "forest"]

def extract_faceurls(obj, urls=None):
    """
    Recursively extract FaceURL with parent Transform positions.
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
                face_url = deck.get("FaceURL")
                if face_url:
                    urls.append({
                        "url": face_url,
                        "posX": posX,
                        "posZ": posZ,
                        "posX_sort": posX_sort,
                        "posZ_sort": posZ_sort
                    })

        for v in obj.values():
            extract_faceurls(v, urls)

    elif isinstance(obj, list):
        for item in obj:
            extract_faceurls(item, urls)

    return urls

def main():
    if len(sys.argv) < 2:
        print("Usage: python script.py <json_file> --debug")
        sys.exit(1)

    json_file = sys.argv[1]
    debug = "--debug" in sys.argv

    with open(json_file, "r", encoding="utf-8") as f:
        data = json.load(f)

    faceurls_with_pos = extract_faceurls(data)
    # faceurls_with_pos = faceurls_with_pos[2:]  # keeps everything from index 2 onward

    # Sort: top-to-bottom (Z descending), left-to-right (X ascending) using rounded even numbers
    faceurls_with_pos.sort(key=lambda x: (-x["posZ_sort"], x["posX_sort"]))

    # Output Lua table
    group = 1
    print("local landImages = {")
    for i, item in enumerate(faceurls_with_pos):
        label = labels[i % len(labels)]  # repeat labels cyclically
        if debug:
            print(f"{item['url']}  |  posX: {item['posX']}, posZ: {item['posZ']} (rounded: X={item['posX_sort']}, Z={item['posZ_sort']})")
        else:
            print(f'    {{label="{label}", url="{item['url']}", group="{group}"}}, ')
        if label == 'forest':
            group += 1
    print("}")

if __name__ == "__main__":
    main()
