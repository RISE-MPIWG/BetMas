xquery version "3.1";
(:
exrest:register-module(xs:anyURI("/db/apps/gez-en/modules/lists.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/compare.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/dts.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/iiif.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/items.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/rest.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/sparqlRest.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/viewer.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/user.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/places.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/search.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/ids.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/collatex.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/apiSearch.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/apiText.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/apiTitles.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/apiSearch.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/chojnacki.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/clavis.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/enrichSdCtable.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/indexsNE.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/LitFlowRest.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/nodesAndEdges.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/quotations.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/relations.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/roles.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/sharedKeywords.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/void.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/wikitable.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/wordCount.xqm")),
exrest:register-module(xs:anyURI("/db/apps/gez-en/modules/rest.xqm")),
exrest:register-module(xs:anyURI("/db/apps/gez-en/modules/rest.xqm")),
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/attestations.xqm")),:)
exrest:register-module(xs:anyURI("/db/apps/BetMas/modules/workmap.xqm"))
