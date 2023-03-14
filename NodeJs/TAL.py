import sys


demande = {
    "type_opeation": "",
    "nom": "",
}


def type_requette(req):
    req=req.lower()
    global type
    if "joue" in req.lower() or "play" in req.lower() or "commence" in req.lower() or "lance" in req.lower():
        if "joue" in req.lower():
            chanson_demandee_str = req.split("joue", 1)[1].strip()
        if "play" in req.lower():
            chanson_demandee_str = req.split("play", 1)[1].strip()
        if "commence" in req.lower():
            chanson_demandee_str = req.split("commence", 1)[1].strip()
        if "lance" in req.lower():
            chanson_demandee_str = req.split("lance", 1)[1].strip()

        type = {"type_opeation": "start"}
        chanson_demandee = {"nom": chanson_demandee_str}
    elif "stop" in req.lower() or "arrête" in req.lower():
        if "stop" in req.lower():
            chanson_demandee_str = req.split("stop", 1)[1].strip()
        if "arrête" in req.lower():
            chanson_demandee_str = req.split("arrête", 1)[1].strip()

        type = {"type_opeation": "stop"}
        chanson_demandee = {"nom": chanson_demandee_str}
    elif "supprimer" in req.lower() or "delete" in req.lower():
        if "supprimer" in req.lower():
            chanson_demandee_str = req.split("supprimer", 1)[1].strip()
        if "delete" in req.lower():
            chanson_demandee_str = req.split("delete", 1)[1].strip()
        type = {"type_opeation": "supprimer"}

        chanson_demandee = {"nom": chanson_demandee_str}
    else:
        type = {"type_opeation": ""}
        chanson_demandee = {"nom": ""}
    demande.update(type)
    demande.update(chanson_demandee)


def requetteTal(req):
    type_requette(req)
    print(demande)


requetteTal(sys.argv[1])
