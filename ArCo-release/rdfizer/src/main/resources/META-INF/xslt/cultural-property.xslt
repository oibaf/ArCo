<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl"
	xmlns:arco-fn="http://w3id.org/arco/saxon-extension" 
	xmlns:arco-core="https://w3id.org/arco/core/"
	xmlns:arco-ce="https://w3id.org/arco/cultural-event/"
	xmlns:arco-catalogue="https://w3id.org/arco/catalogue/"
	xmlns:arco-dd="https://w3id.org/arco/denotative-description/" xmlns:cis="http://dati.beniculturali.it/cis/"
	xmlns:l0="https://w3id.org/italia/onto/l0/" xmlns:clvapit="https://w3id.org/italia/onto/CLV/"
	xmlns:tiapit="https://w3id.org/italia/onto/TI/" xmlns:roapit="https://w3id.org/italia/onto/RO/"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:dcterms="http://purl.org/dc/terms/creator"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:frbr="http://purl.org/vocab/frbr/core#"
	xmlns:arco-location="https://w3id.org/arco/location/" xmlns:language="https://w3id.org/italia/onto/Language/"
	xmlns:arco-cd="https://w3id.org/arco/context-description/"
	exclude-result-prefixes="xsl php">

	<xsl:output method="xml" encoding="utf-8" indent="yes" />
	<xsl:param name="item" />
	
	<xsl:variable name="itemURI">
		<xsl:choose>
			<xsl:when test="schede/*/RV/RVE/RVEL">
				<xsl:value-of
					select="concat(schede/*/CD/NCT/NCTR, schede/*/CD/NCT/NCTN, schede/*/CD/NCT/NCTS, '-', arco-fn:urify(normalize-space(schede/*/RV/RVE/RVEL)))" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="concat(schede/*/CD/NCT/NCTR, schede/*/CD/NCT/NCTN, schede/*/CD/NCT/NCTS)" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="NS" select="'https://w3id.org/arco/resource/'" />
	
	<xsl:variable name="culturalPropertyComponent"
			select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI, '-component')" />

		<xsl:variable name="culturalProperty"
			select="concat($NS, arco-fn:local-name(arco-fn:getSpecificPropertyType($sheetType)), '/', $itemURI)" />
	
	<xsl:variable name="sheetVersion" select="schede/*/@version"></xsl:variable>
	<xsl:variable name="sheetType" select="name(schede/*)"></xsl:variable>
	<xsl:variable name="cp-name" select="''"></xsl:variable>
	
	<xsl:variable name="objectOfDescription">
		<xsl:choose>
			<xsl:when test="schede/*/OG/OGT/OGTP and ($sheetVersion='4.00_ICCD0' or $sheetVersion='4.00')">
				<xsl:value-of select="$culturalPropertyComponent" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$culturalProperty" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- xsl:import href="part.xsl" / -->
	
	<xsl:template match="/">

		<xsl:variable name="ogtp"
			select="normalize-space(schede/*/OG/OGT/OGTP)" />


		<!-- variable ogtt -->
		<xsl:variable name="ogtt">
			<xsl:choose>
				<xsl:when test="schede/*/OG/OGT/OGTT">
					<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTT)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- variable sgta -->
		<xsl:variable name="sgta">
			<xsl:choose>
				<xsl:when test="schede/*/OG/SGT/SGTA">
					<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTA)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- variable sgti -->
		<xsl:variable name="sgti">
			<xsl:choose>
				<xsl:when test="schede/*/OG/SGT/SGTI and (not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTI)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTI)), 'n.r')))">
					<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTI)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<rdf:RDF>
			
			<xsl:if test="schede/*/OG/OGT/OGTP and ($sheetVersion='4.00_ICCD0' or $sheetVersion='4.00')">
				<rdf:Description>
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$culturalProperty" />
					</xsl:attribute>
					<arco-core:hasCulturalPropertyComponent>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$culturalPropertyComponent" />
						</xsl:attribute>
					</arco-core:hasCulturalPropertyComponent>
				</rdf:Description>

				<rdf:Description>
					<xsl:attribute name="rdf:about">
						<xsl:value-of select="$culturalPropertyComponent" />
					</xsl:attribute>

					<rdf:type rdf:resource="https://w3id.org/arco/core/CulturalPropertyComponent" />
					<rdf:type>
						<xsl:attribute name="rdf:resource">
		                       <xsl:value-of
							select="arco-fn:getPropertyType($sheetType)" />
		                   </xsl:attribute>
					</rdf:type>
					<!-- rdf:type of cultural property -->
					<rdf:type>
						<xsl:attribute name="rdf:resource">
		                       <xsl:value-of
							select="arco-fn:getSpecificPropertyType($sheetType)" />
		                   </xsl:attribute>
					</rdf:type>

					<arco-core:isCulturalPropertyComponentOf>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="$culturalProperty" />
						</xsl:attribute>
					</arco-core:isCulturalPropertyComponentOf>

					<!-- labels of cultural property -->

					<!-- SMO -->
					<!-- la virgola tra ogtd e ogtv viene inserita nella variabile ogtv perché 
						c'è sempre se c'è ogtv. Invece, nella label si mettono le parentesi solo 
						se c'è o sgta o sgti, mentre si mette la virgola tra sgta e sgti solo se 
						ci sono entrambi -->
					<xsl:if test="$sheetType='SMO'">


						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTV))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/SGT/SGTA and schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgta, ', ', $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtv, ')')" />
									</xsl:when>
									<xsl:when test="schede/*/OG/SGT/SGTA or schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgta, $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtv, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtv)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- SM -->
					<!-- la parentesi di apertura viene aggiunta alla variabile ogdn perché 
						c'è solo se c'è ogdn; quindi viene messo un choose per la rdfs:label per 
						inserire la parentesi di chiusura a seconda dell'esistenza o meno di $ogdn. 
						La virgola tra ogtd e ogtt viene messa nella variabile ogtt perché c'è solo 
						se c'è ogtt -->

					<xsl:if test="$sheetType='SM'">
						<xsl:variable name="ogdn">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGD/OGDN">
									<xsl:value-of
										select="concat(normalize-space(schede/*/OG/OGD/OGDN), ' (')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTV))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtw">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTW">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTW))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtp">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTP">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTP))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/OGD/OGDN">
										<xsl:value-of
											select="concat($ogdn, normalize-space(schede/*/OG/OGT/OGTD), $ogtv, $ogtw, $ogtp, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtv, $ogtw, $ogtp)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- PST or SI -->
					<!-- la parentesi di apertura viene aggiunta alla variabile ogtn perché 
						c'è solo se c'è ogtn; quindi viene messo un choose per la rdfs:label per 
						inserire la parentesi di chiusura a seconda dell'esistenza o meno di $ogtn. 
						La virgola tra ogtd e ogtt viene messa nella variabile ogtt perché c'è solo 
						se c'è ogtt -->
					<xsl:if test="$sheetType='PST' or $sheetType='SI'">
						<xsl:variable name="ogtn">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTN">
									<xsl:value-of
										select="concat(normalize-space(schede/*/OG/OGT/OGTN), ' (')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtt">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTT">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTT))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/OGT/OGTN">
										<xsl:value-of
											select="concat($ogtn, normalize-space(schede/*/OG/OGT/OGTD), $ogtt, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtt)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>

					<!-- RA -->
					<!-- le parentesi vengono inserite in choose nella label perché ci sono 
						solo se c'è $sgti. Invece, le virgole tra ogtd e ogtt e tra ogtt e ogtn vengono 
						messe nelle variabili $ogtt e $ogtn perché sono sempre presenti se ci sono 
						ogtt e ogtn -->
					<xsl:if test="$sheetType='RA'">
						<xsl:variable name="ogtt">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTT">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTT))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtn">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTN">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTN))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="sgti">
							<xsl:choose>
								<xsl:when test="schede/*/OG/SGT/SGTI">
									<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTI)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtn, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtn)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>

					<!-- OA -->
					<!-- la virgola tra ogtd o ogtt e ogtv viene inserita nella variabile 
						ogtv perché c'è sempre se c'è ogtv. Il trattino tra ogtd e ogtt viene inserito 
						nella variabile ogtt perché c'è sempre se c'è ogtt. Invece, nella label si 
						mettono le parentesi solo se c'è o sgta o sgti, mentre si mette la virgola 
						tra sgta e sgti solo se ci sono entrambi -->

					<xsl:if test="$sheetType='OA'">
						<xsl:variable name="sgtt">
							<xsl:choose>
								<xsl:when test="schede/*/OG/SGT/SGTT and (not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTT)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTT)), 'n.r')))">
									<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTT)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="sgti">
							<xsl:choose>
								<xsl:when test="schede/*/OG/SGT/SGTI and (not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTI)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTI)), 'n.r')))">
									<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTI)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtt">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTT and (not(starts-with(lower-case(normalize-space(schede/*/OG/OGT/OGTT)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/OG/OGT/OGTT)), 'n.r')))">
									<xsl:value-of
										select="concat(' - ', normalize-space(schede/*/OG/OGT/OGTT))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV and (not(starts-with(lower-case(normalize-space(schede/*/OG/OGT/OGTV)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/OG/OGT/OGTV)), 'n.r')))">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTV))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/SGT/SGTT and schede/*/OG/SGT/SGTI and (not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTT)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTT)), 'n.r'))) and (not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTI)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/OG/SGT/SGTI)), 'n.r')))">
										<xsl:value-of
											select="concat($sgtt, ', ', $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtv, ')')" />
									</xsl:when>
									<xsl:when test="schede/*/OG/SGT/SGTT or schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgtt, $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtv, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtv)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- F -->
					<!-- Le parentesi le mettiamo nella label, ci sono sempre perché sia 
						sgti sia ogtd sono obbligatori. Le virgole tra ogtd ogtv ogtw ogtp le mettiamo 
						nelle tre variabili perché ci sono sempre se ci sono quegli elementi -->
					<xsl:if test="$sheetType='F'">
						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTV))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtw">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTW">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTW))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTV))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:value-of
								select="concat(normalize-space(schede/*/SG/SGT/SGTI), ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtv, $ogtw, ' - ', $ogtp, ')')" />
						</rdfs:label>
					</xsl:if>


					<!-- SAS -->
					<xsl:if test="$sheetType='SAS'">
						<rdfs:label>
							<xsl:value-of
								select="concat(normalize-space(schede/*/OG/OGT/OGTD), ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- CA or MA -->
					<!-- la parentesi di apertura viene aggiunta alla variabile ogtn perché 
						c'è solo se c'è ogtn; quindi viene messo un choose per la rdfs:label per 
						inserire la parentesi di chiusura a seconda dell'esistenza o meno di $ogtn. 
						La virgola tra ogtd e ogtt viene messa nella variabile ogtc perché c'è solo 
						se c'è ogtc -->
					<xsl:if test="$sheetType='CA' or $sheetType='MA'">
						<xsl:variable name="ogtn">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTN">
									<xsl:value-of
										select="concat(normalize-space(schede/*/OG/OGT/OGTN), ' (')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtc">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTC">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTC))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/OGT/OGTN">
										<xsl:value-of
											select="concat($ogtn, normalize-space(schede/*/OG/OGT/OGTD), $ogtc, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtc)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>

					<!-- AT -->
					<!-- la virgola tra ogtd e ogtv viene inserita nella variabile ogtv 
						perché c'è sempre se c'è ogtv. Lo stesso per la virgola tra ogtd e ogtt perché 
						sono entrambi obbligatori. La parentesi di apertura e quella di chiusura 
						sono messe nella label solo se c'è o ogtm o ogtp; la virgola tra ogtm e ogtp 
						viene messa nella label solo se ci sono entrambi -->
					<xsl:if test="$sheetType='AT'">
						<xsl:variable name="ogtm">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTM">
									<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTM)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtp">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTP">
									<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTP)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/OGT/OGTM and schede/*/OG/OGT/OGTP">
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), ', ', normalize-space(schede/*/OG/OGT/OGTT), ' (', $ogtm, ', ', $ogtp, ')')" />
									</xsl:when>
									<xsl:when test="schede/*/OG/OGT/OGTM or schede/*/OG/OGT/OGTP">
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), ', ', normalize-space(schede/*/OG/OGT/OGTT), ' (', $ogtm, $ogtp, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), ', ', normalize-space(schede/*/OG/OGT/OGTT))" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- TMA -->

					<xsl:if test="$sheetType='TMA'">
						<rdfs:label>
						<xsl:variable name="tmpLabel">
							<xsl:value-of
								select="concat(normalize-space(schede/*/OG/OGT/OGTD), ' (', normalize-space(schede/*/OG/OGT/OGTM), ')')" />
						</xsl:variable>
						<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>

					<!-- NU -->
					<!-- sia virgola tra ogtt e ogth sia parentesi sono inserite nel choose 
						della label perché la virgola c'è solo se ci sono entrambe le variabili, 
						le parentesi solo se ce ne sono entrambe o una delle due -->
					<xsl:if test="$sheetType='NU'">

						<xsl:variable name="ogth">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTH">
									<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTH)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>


						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/OGT/OGTT and schede/*/OG/OGT/OGTH">
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), ' (', $ogtt, ', ', $ogth, ')')" />
									</xsl:when>
									<xsl:when test="schede/*/OG/OGT/OGTT or schede/*/OG/OGT/OGTH">
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), ' (', $ogtt, $ogth, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTD)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- OAC -->
					<!-- nella label si mettono le parentesi solo se c'è o sgta o sgti, 
						mentre si mette la virgola tra sgta e sgti solo se ci sono entrambi -->

					<xsl:if test="$sheetType='OAC'">
						<xsl:variable name="sgtt">
							<xsl:choose>
								<xsl:when test="schede/*/OG/SGT/SGTT">
									<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTT)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="sgti">
							<xsl:choose>
								<xsl:when test="schede/*/OG/SGT/SGTI">
									<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTI)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>


						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/SGT/SGTT and schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgtt, ', ', $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), ')')" />
									</xsl:when>
									<xsl:when test="schede/*/OG/SGT/SGTT or schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgtt, $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTD)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>

					<!-- D or MI or S -->
					<!-- la virgola tra ogtd e ogtv viene inserita nella variabile ogtv 
						perché c'è sempre se c'è ogtv. Invece, nella label si mettono le parentesi 
						solo se c'è o sgta o sgti, mentre si mette la virgola tra sgta e sgti solo 
						se ci sono entrambi -->

					<xsl:if test="$sheetType='D' or $sheetType='MI' or $sheetType='S'">
						<xsl:variable name="sgtt">
							<xsl:choose>
								<xsl:when test="schede/*/OG/SGT/SGTT">
									<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTT)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="sgti">
							<xsl:choose>
								<xsl:when test="schede/*/OG/SGT/SGTI">
									<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTI)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTV))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/SGT/SGTT and schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgtt, ', ', $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtv, ')')" />
									</xsl:when>
									<xsl:when test="schede/*/OG/SGT/SGTT or schede/*/OG/SGT/SGTI">
										<xsl:value-of
											select="concat($sgtt, $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtv, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtv)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>



					<!-- VeAC -->
					<!-- la parentesi di apertura viene aggiunta alla variabile ogtn perché 
						c'è solo se c'è ogtn; quindi viene messo un choose per la rdfs:label per 
						inserire la parentesi di chiusura a seconda dell'esistenza o meno di $ogtn. 
						Le virgole tra OGTD e $ogtc, $ogtf, $ogtg vengono messe nelle variabili perché 
						ci sono solo se ci sono quei campi -->
					<xsl:if test="$sheetType='VeAC'">
						<xsl:variable name="ogtn">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTN">
									<xsl:value-of
										select="concat(normalize-space(schede/*/OG/OGT/OGTN), ' (')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtc">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTC">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTC))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtf">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTF">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTF))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtg">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTG">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTG))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/OGT/OGTN">
										<xsl:value-of
											select="concat($ogtn, normalize-space(schede/*/OG/OGT/OGTD), $ogtc, $ogtf, $ogtg, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtc, $ogtf, $ogtg)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>

					<!-- A -->
					<!-- la parentesi di apertura viene aggiunta alla variabile ogtn perché 
						c'è solo se c'è ogtn; quindi viene messo un choose per la rdfs:label per 
						inserire la parentesi di chiusura a seconda dell'esistenza o meno di $ogtn. 
						La virgola tra ogtd e ogtq viene messa nella variabile ogtq perché c'è solo 
						se c'è ogtq -->
					<xsl:if test="$sheetType='A'">
						<xsl:choose>
							<xsl:when test="$sheetVersion='3.00_ICCD0' or $sheetVersion='3.00'">
								<xsl:variable name="ogtn">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGT/OGTN">
											<xsl:value-of
												select="concat(normalize-space(schede/*/OG/OGT/OGTN), ' (')" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ogtq">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGT/OGTQ">
											<xsl:value-of
												select="concat(', ', normalize-space(schede/*/OG/OGT/OGTQ))" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<rdfs:label>
									<xsl:variable name="tmpLabel">
										<xsl:choose>
											<xsl:when test="schede/*/OG/OGT/OGTN">
												<xsl:value-of
													select="concat($ogtn, normalize-space(schede/*/OG/OGT/OGTD), $ogtq, ')')" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtq)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
								</rdfs:label>
							</xsl:when>
							<xsl:otherwise>
								<!-- la parentesi di chiusura è inserita nel choose della label perché c'è solo se c'è $ogtd; 
						la parentesi di apertura è nella variabile $ogtd perché c'è solo se c'è $ogtd; la virgola tra OGTT e $ogtq è nella variabile
						$ogtq perché c'è sempre se c'è ogtq -->
								<xsl:variable name="ogtd">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGT/OGTD">
											<xsl:value-of select="concat(normalize-space(schede/*/OG/OGT/OGTD), ' (')" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ogtq">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGT/OGTQ">
											<xsl:value-of select="concat(', ', normalize-space(schede/*/OG/OGT/OGTQ))" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>


								<rdfs:label>
									<xsl:variable name="tmpLabel">
										<xsl:choose>
											<xsl:when test="schede/*/OG/OGT/OGTD">
												<xsl:value-of
										select="concat($ogtd, normalize-space(schede/*/OG/OGT/OGTT), $ogtq, ')')" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="concat(normalize-space(schede/*/OG/OGT/OGTT), $ogtq)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
								</rdfs:label>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<!-- PG -->
					<!-- le parentesi vengono messe nella label perché ci sono sempre, essendo 
						sia ogtn sia ogtd obbligatori. Le virgole tra ogtd e ogtq e tra ogtq e ogad 
						vengono messe nella variabili ogtq e ogad perché ci sono solo quando ci sono 
						quei campi -->
					<xsl:if test="$sheetType='PG'">
						<xsl:variable name="ogtq">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTQ">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTQ))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogad">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGA/OGAD">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGA/OGAD))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:value-of
								select="concat(normalize-space(schede/*/OG/OGT/OGTN), ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtq, ')', $ogad, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- BDI -->
					<xsl:if test="$sheetType='BDI'">
						<xsl:choose>
							<xsl:when
								test="$sheetVersion='3.00_ICCD0' or $sheetVersion='3.00' or $sheetVersion='3.01_ICCD0' or $sheetVersion='3.01'">
								<!-- la virgola tra dbd e dbl viene inserita nella variabile dbl 
									perché c'è sempre se c'è dbl. Le parentesi di dbc vengono messe nella label 
									perché dbd e dbc sono obbligatori quindi ci sono sempre -->
								<xsl:variable name="dbl">
								<xsl:choose>
									<xsl:when test="schede/*/DB/DBL">
									<!-- si usa il for-each perché DBL è ripetitivo -->
										<xsl:for-each select="schede/*/DB/DBL">
											<xsl:value-of select="concat(', ', normalize-space(.))" />
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="''" />
									</xsl:otherwise>
								</xsl:choose>
						</xsl:variable>

								<rdfs:label>
								<xsl:variable name="tmpLabel">
									<xsl:value-of
										select="concat(normalize-space(schede/*/DB/DBD), $dbl, ' (', normalize-space(schede/*/DB/DBC), ')')" />
								</xsl:variable>
								<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
								</rdfs:label>
							</xsl:when>
							<xsl:otherwise>
								<!-- la parentesi di apertura viene aggiunta alla variabile ogdn 
									perché c'è solo se c'è ogdn; quindi viene messo un choose per la rdfs:label 
									per inserire la parentesi di chiusura a seconda dell'esistenza o meno di 
									$ogdn. Le virgole tra ogtd, ogtt e ctg vengono messe nelli variabili ogtt 
									perché ci sono solo se ci sono quei campi -->
								<xsl:variable name="ogdn">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGD/OGDN">
											<xsl:value-of
												select="concat(normalize-space(schede/*/OG/OGT/OGDN), ' (')" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<rdfs:label>
									<xsl:variable name="tmpLabel">
										<xsl:choose>
											<xsl:when test="schede/*/OG/OGD/OGDN">
												<xsl:value-of
													select="concat($ogdn, normalize-space(schede/*/OG/OGT/OGTD), ', ', normalize-space(schede/*/OG/CTG), ')')" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="concat(normalize-space(schede/*/OG/OGT/OGTD), ', ', normalize-space(schede/*/OG/CTG))" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
								</rdfs:label>

							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>


					<!-- BDM -->
					<xsl:if test="$sheetType='BDM'">
						<xsl:choose>
							<xsl:when test="$sheetVersion='2.00_ICCD0' or $sheetVersion='2.00'">
								<!-- la virgola tra ogtd o ogtt e ogtg viene inserita nella variabile 
									ogtg perché c'è sempre se c'è ogtv. La virgola tra ogtd e ogtt viene inserita 
									nella variabile ogtt perché c'è sempre se c'è ogtt. Invece, nella label si 
									mettono le parentesi solo se c'è o sgta o sgti, mentre si mette la virgola 
									tra sgta e sgti solo se ci sono entrambi -->
								<xsl:variable name="sgtt">
									<xsl:choose>
										<xsl:when test="schede/*/OG/SGT/SGTT">
											<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTT)" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="sgti">
									<xsl:choose>
										<xsl:when test="schede/*/OG/SGT/SGTI">
											<xsl:value-of select="normalize-space(schede/*/OG/SGT/SGTI)" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ogtt">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGT/OGTT">
											<xsl:value-of
												select="concat(', ', normalize-space(schede/*/OG/OGT/OGTT))" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ogtg">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGT/OGTG">
											<xsl:value-of
												select="concat(', ', normalize-space(schede/*/OG/OGT/OGTG))" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<rdfs:label>
									<xsl:variable name="tmpLabel">
										<xsl:choose>
											<xsl:when test="schede/*/OG/SGT/SGTT and schede/*/OG/SGT/SGTI">
												<xsl:value-of
													select="concat($sgtt, ', ', $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtg, ')')" />
											</xsl:when>
											<xsl:when test="schede/*/OG/SGT/SGTT or schede/*/OG/SGT/SGTI">
												<xsl:value-of
													select="concat($sgtt, $sgti, ' (', normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtg, ')')" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ogtg)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
								</rdfs:label>
							</xsl:when>
							<xsl:otherwise>
								<!-- la parentesi di apertura viene aggiunta alla variabile ogdn 
									perché c'è solo se c'è ogdn; quindi viene messo un choose per la rdfs:label 
									per inserire la parentesi di chiusura a seconda dell'esistenza o meno di 
									$ogdn. Le virgole tra ogtd, ogtt e ctg vengono messe nelli variabili ogtt 
									perché ci sono solo se ci sono quei campi -->
								<xsl:variable name="ogdn">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGD/OGDN">
											<xsl:value-of
												select="concat(normalize-space(schede/*/OG/OGT/OGDN), ' (')" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ogtt">
									<xsl:choose>
										<xsl:when test="schede/*/OG/OGT/OGTT">
											<xsl:value-of
												select="concat(', ', normalize-space(schede/*/OG/OGT/OGTT))" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ctg">
									<xsl:choose>
										<xsl:when test="schede/*/OG/CTG">
											<xsl:value-of
												select="concat(', ', normalize-space(schede/*/OG/CTG))" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="''" />
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>

								<rdfs:label>
									<xsl:variable name="tmpLabel">
										<xsl:choose>
											<xsl:when test="schede/*/OG/OGD/OGDN">
												<xsl:value-of
													select="concat($ogdn, normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ctg, ')')" />
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
													select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtt, $ctg)" />
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
									<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
								</rdfs:label>

							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>

					<!-- BNB -->
					<!-- il trattino tra nbna e le virgole tra ogtd e ogte e tra ogte e 
						ogtc vengono messe nelle variabili perché la loro esistenza dipende dall'esistenza 
						di quei campi -->
					<xsl:if test="$sheetType='BNB'">
						<xsl:variable name="nbna">
							<xsl:choose>
								<xsl:when test="schede/*/SB/NBN/NBNA">
									<xsl:value-of
										select="concat(normalize-space(schede/*/SB/NBN/NBNA), ' - ')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogte">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTE">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTE))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtc">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTC">
									<xsl:value-of
										select="concat(', ', normalize-space(schede/*/OG/OGT/OGTC))" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:value-of
								select="concat($nbna, normalize-space(schede/*/OG/OGT/OGTD), $ogte, $ogtc, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>

					<!-- BNM or BNPE or BNZ or E -->
					<!-- le parentesi vengono inserite nella variabile ogtv perché ci sono 
						solo se c'è ogtv -->
					<xsl:if
						test="$sheetType='BNPE' or $sheetType='BNM' or $sheetType='BNZ' or $sheetType='E'">
						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV">
									<xsl:value-of
										select="concat(' (', normalize-space(schede/*/OG/OGT/OGTV), ')')" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>

						<rdfs:label>
							<xsl:value-of
								select="concat(normalize-space(schede/*/OG/OGT/OGTD), $ogtv, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- BNP -->
					<!-- sia virgola tra ogtt e ogtv sia parentesi sono inserite nel choose 
						della label perché la virgola c'è solo se ci sono entrambe le variabili, 
						le parentesi solo se ce ne sono entrambe o una delle due -->
					<xsl:if test="$sheetType='BNP'">
						<xsl:variable name="ogtt">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTT">
									<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTT)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="ogtv">
							<xsl:choose>
								<xsl:when test="schede/*/OG/OGT/OGTV">
									<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTV)" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="''" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>


						<rdfs:label>
							<xsl:variable name="tmpLabel">
								<xsl:choose>
									<xsl:when test="schede/*/OG/OGT/OGTT and schede/*/OG/OGT/OGTV">
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), ' (', $ogtt, ', ', $ogtv, ')')" />
									</xsl:when>
									<xsl:when test="schede/*/OG/OGT/OGTT or schede/*/OG/OGT/OGTV">
										<xsl:value-of
											select="concat(normalize-space(schede/*/OG/OGT/OGTD), ' (', $ogtt, $ogtv, ')')" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="normalize-space(schede/*/OG/OGT/OGTD)" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:value-of select="concat($tmpLabel, ' - ', $ogtp)" />
						</rdfs:label>
					</xsl:if>


					<!-- FF -->
					<!-- in attesa di indicazioni da Chiara Veninata -->
				</rdf:Description>

			</xsl:if>
			
			<rdf:Description>
				<xsl:attribute name="rdf:about">
                    <xsl:value-of
					select="concat($NS, 'CatalogueRecord', $sheetType, '/', $itemURI)" />
                </xsl:attribute>
                
                <arco-catalogue:describesCulturalProperty>
					<xsl:attribute name="rdf:resource">
                        <xsl:value-of
							select="$objectOfDescription" />
                    </xsl:attribute>
				</arco-catalogue:describesCulturalProperty>
            </rdf:Description>

			<rdf:Description>
				<xsl:attribute name="rdf:about">
					<xsl:value-of select="$objectOfDescription" />
				</xsl:attribute>


				<xsl:variable name="related-property" select="arco-fn:related-property(normalize-space(./RSEC), 'foaf')" />
				<xsl:if test="count($related-property) > 0" >
					<!-- Rule #RWS -->
					<xsl:for-each select="schede/*/RV/RSE">
						<xsl:if test="./* 
						and (not(starts-with(lower-case(normalize-space(./RSEC)), 'nr')) and not(starts-with(lower-case(normalize-space(./RSEC)), 'n.r')))">
							<arco-cd:hasRelatedWorkSituation>
								<xsl:attribute name="rdf:resource">
									<!-- The individual typed as RelatedWorkSituation is created within the arco.xslt sheet. -->
									<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-typed-related-cultural-property-', position())" />
								</xsl:attribute>
							</arco-cd:hasRelatedWorkSituation>	
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				
				<xsl:for-each select="schede/*/RV/ROZ">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
								<!-- The individual typed as RelatedWorkSituation is created within the arco.xslt sheet. -->
								<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-related-cultural-property-', position())" />
							</xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>	
				</xsl:for-each>
				
				<!-- tiratura di una fotografia o di una stampa -->
				<xsl:if test="schede/*/PD/TRT and (not(starts-with(lower-case(normalize-space(schede/*/PD/TRT)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/PD/TRT)), 'n.r')))">
					<arco-cd:numberInCirculation>
						<xsl:value-of select="normalize-space(schede/*/PD/TRT)" />
					</arco-cd:numberInCirculation>
				</xsl:if>
				<xsl:if test="schede/*/AU/TRT/TRTN and (not(starts-with(lower-case(normalize-space(schede/*/AU/TRT/TRTN)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/AU/TRT/TRTN)), 'n.r')))">
					<arco-cd:numberInCirculation>
						<xsl:value-of select="normalize-space(schede/*/AU/TRT/TRTN)" />
					</arco-cd:numberInCirculation>
				</xsl:if>
				
				<!-- isDescribedByCatalogueRecord -->
				<arco-catalogue:isDescribedByCatalogueRecord>
					<xsl:attribute name="rdf:resource">
                    <xsl:value-of
					select="concat($NS, 'CatalogueRecord', $sheetType, '/', $itemURI)" />
                </xsl:attribute>
				</arco-catalogue:isDescribedByCatalogueRecord>
				<!-- current physical location -->
				<xsl:if test="schede/*/LC">
					<arco-location:hasTimeIndexedTypedLocation>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'TimeIndexedTypedLocation/', $itemURI, '-current')" />
	                        </xsl:attribute>
					</arco-location:hasTimeIndexedTypedLocation>
				</xsl:if>
				<!-- alternative locations -->
				<xsl:for-each select="schede/*/LA">
					<arco-location:hasTimeIndexedTypedLocation>
								<xsl:attribute name="rdf:resource">
									 <xsl:value-of
								select="concat($NS, 'TimeIndexedTypedLocation/', $itemURI, '-alternative-', position())" />
								</xsl:attribute>
					</arco-location:hasTimeIndexedTypedLocation>
				</xsl:for-each>
				<!-- shot location -->
				<xsl:if test="schede/F/LR">
					<arco-location:hasTimeIndexedTypedLocation>
								<xsl:attribute name="rdf:resource">
									 <xsl:value-of
								select="concat($NS, 'TimeIndexedTypedLocation/', $itemURI, '-shot')" />
								</xsl:attribute>
					</arco-location:hasTimeIndexedTypedLocation>
				</xsl:if>
				<xsl:if test="schede/*/LC/PVC/*">
					<arco-location:hasCulturalPropertyAddress>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'Address/', arco-fn:urify(arco-fn:md5(concat(normalize-space(schede/*/LC/PVC), normalize-space(schede/*/LC/PVL), normalize-space(schede/*/LC/LDC/LDCU)))))" />
	                        </xsl:attribute>
					</arco-location:hasCulturalPropertyAddress>
				</xsl:if>
				<!-- has number of components -->
				<xsl:if
					test="schede/*/OG/QNT/QNTN or schede/*/OG/QNT/QNTI or schede/*/OG/QNT/QNTS">
					<arco-core:hasNumberOfComponents>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'NumberOfComponents/', $itemURI, '-quantity')" />
	                        </xsl:attribute>
					</arco-core:hasNumberOfComponents>
				</xsl:if>
				<!-- cultural property description -->
				<xsl:if test="schede/*/DA/DES">
					<xsl:choose>
						<xsl:when test="schede/*/DA/DES/DESO">
							<xsl:if
								test="not(lower-case(normalize-space(schede/*/DA/DES/DESO))='nr' or lower-case(normalize-space(schede/*/DA/DES/DESO))='n.r.' or lower-case(normalize-space(schede/*/DA/DES/DESO))='nr (recupero pregresso)')">
								<arco-core:description>
									<xsl:value-of select="normalize-space(schede/*/DA/DES/DESO)" />
								</arco-core:description>
							</xsl:if>
						</xsl:when>
						<xsl:when test="not(schede/*/DA/DES/*)">
							<arco-core:description>
								<xsl:value-of select="normalize-space(schede/*/DA/DES)" />
							</arco-core:description>
						</xsl:when>
					</xsl:choose>
				</xsl:if>
				<!-- keywords (PST) -->
				<xsl:if test="(not(starts-with(lower-case(normalize-space(schede/*/CT/CTC)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/CT/CTC)), 'n.r')))">
					<xsl:for-each select="schede/*/CT/CTC">
						<arco-core:hasKeyword>
							<xsl:attribute name="rdf:resource">
		                		<xsl:value-of select="concat($NS, 'Keyword/', arco-fn:urify(normalize-space(.)))" />
		                	</xsl:attribute>
						</arco-core:hasKeyword>
					</xsl:for-each>
				</xsl:if>
				<!-- main discipline (PST) -->
				<xsl:if test="(not(starts-with(lower-case(normalize-space(schede/*/CT/CTP)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/CT/CTP)), 'n.r')))">
					<xsl:for-each select="schede/*/CT/CTP">
						<arco-core:hasMainDiscipline>
							<xsl:attribute name="rdf:resource">
		                		<xsl:value-of select="concat($NS, 'SubjectDiscipline/', arco-fn:urify(normalize-space(.)))" />
		                	</xsl:attribute>
						</arco-core:hasMainDiscipline>
					</xsl:for-each>
				</xsl:if>
				<!-- alternative discipline (PST) -->
				<xsl:if test="(not(starts-with(lower-case(normalize-space(schede/*/CT/CTA)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/CT/CTA)), 'n.r')))">
					<xsl:for-each select="schede/*/CT/CTA">
						<arco-core:hasAlternativeDiscipline>
							<xsl:attribute name="rdf:resource">
		                		<xsl:value-of select="concat($NS, 'SubjectDiscipline/', arco-fn:urify(normalize-space(.)))" />
		                	</xsl:attribute>
						</arco-core:hasAlternativeDiscipline>
					</xsl:for-each>
				</xsl:if>
				<!-- cadastrial identity -->
				<xsl:for-each select="schede/*/CS">
					<arco-location:hasCadastrialIdentity>
							<xsl:attribute name="rdf:resource">
		                		<xsl:value-of select="concat($NS, 'CadastrialIdentity/', $itemURI, '-', position())" />
		                	</xsl:attribute>
					</arco-location:hasCadastrialIdentity>
				</xsl:for-each>
				<!-- historical cadastrial identity -->
				<xsl:if test="schede/*/LS/CSS/*">
				<xsl:for-each select="schede/*/LS/CSS">
					<arco-location:hasCadastrialIdentity>
							<xsl:attribute name="rdf:resource">
		                		<xsl:value-of select="concat($NS, 'CadastrialIdentity/', $itemURI, '-historical-', position())" />
		                	</xsl:attribute>
					</arco-location:hasCadastrialIdentity>
				</xsl:for-each>
				</xsl:if>
				<!-- fruition (VeAC) -->
				<xsl:if test="schede/*/AU/FRU">
					<xsl:for-each select="schede/*/AU/FRU">
						<arco-cd:hasFruition>
							<xsl:attribute name="rdf:resource">
	                				<xsl:value-of
								select="concat($NS, 'Fruition/', $itemURI, '-', position())" />
	                			</xsl:attribute>
						</arco-cd:hasFruition>
					</xsl:for-each>
				</xsl:if>
				<!-- authorship attribution -->
				<xsl:for-each select="schede/*/AU/ATB">
				<xsl:if test="(not(starts-with(lower-case(normalize-space(./ATBD)), 'nr')) and not(starts-with(lower-case(normalize-space(./ATBD)), 'n.r')))">
					<arco-cd:hasAuthorshipAttribution>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'CulturalScopeAttribution/', $itemURI, '-cultural-scope-attribution-', position())" />
	                        </xsl:attribute>
					</arco-cd:hasAuthorshipAttribution>
				</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="schede/*/AU/AAT">
					<arco-cd:hasAuthorshipAttribution>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'AlternativeAuthorshipAttribution/', $itemURI, '-', position())" />
	                        </xsl:attribute>
					</arco-cd:hasAuthorshipAttribution>
				</xsl:for-each>
				<xsl:for-each select="schede/*/AU/AUT | schede/F/AU/AUF">
				<xsl:if test="(not(starts-with(lower-case(normalize-space(./AUTN)), 'nr')) and not(starts-with(lower-case(normalize-space(./AUTN)), 'n.r')) and not(starts-with(lower-case(normalize-space(../AUF/AUFN)), 'n.r')) and not(starts-with(lower-case(normalize-space(../AUF/AUFB)), 'n.r')) and not(starts-with(lower-case(normalize-space(../AUF/AUFB)), 'nr')) and not(starts-with(lower-case(normalize-space(../AUF/AUFN)), 'nr')))">
				<xsl:choose>
					<xsl:when test="./* and (not(./AUTW) or ./AUTW='intero bene' or ./AUTW='integrale' or ./AUTW='tutta' or ./AUTW='totale') or (starts-with(lower-case(normalize-space(./AUTW)), 'nr')) or (starts-with(lower-case(normalize-space(./AUTW)), 'n.r')) or (starts-with(lower-case(normalize-space(./AUTW)), 'intero')) or (starts-with(lower-case(normalize-space(./AUTW)), 'intera')) or (starts-with(lower-case(normalize-space(./AUTW)), 'esemplar'))">
						<arco-cd:hasAuthorshipAttribution>
							<xsl:attribute name="rdf:resource">
		                            <xsl:value-of
								select="concat($NS, 'PreferredAuthorshipAttribution/', $itemURI, '-', position())" />
		                        </xsl:attribute>
						</arco-cd:hasAuthorshipAttribution>
						<arco-core:hasAuthor>
							<xsl:attribute name="rdf:resource">
		                    		<xsl:variable name="author">
				                            <xsl:choose>
				                                <xsl:when test="./AUTA and (not(starts-with(lower-case(normalize-space(./AUTA)), 'nr')) and not(starts-with(lower-case(normalize-space(./AUTA)), 'n.r')))">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(./AUTN)), '-', arco-fn:urify(normalize-space(./AUTA)))" />
				                                </xsl:when>
				                                <xsl:when
								test="../AUF/AUFA and ../AUF/AUFN and (not(starts-with(lower-case(normalize-space(../AUF/AUFA)), 'nr')) and not(starts-with(lower-case(normalize-space(../AUF/AUFA)), 'n.r')))">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFN)), '-', arco-fn:urify(normalize-space(../AUF/AUFA)))" />
				                                </xsl:when>
				                                <xsl:when
								test="../AUF/AUFA and ../AUF/AUFB and (not(starts-with(lower-case(normalize-space(../AUF/AUFA)), 'nr')) and not(starts-with(lower-case(normalize-space(../AUF/AUFA)), 'n.r')))">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFB)), '-', arco-fn:urify(normalize-space(../AUF/AUFA)))" />
				                                </xsl:when>
				                                <xsl:when test="../AUF/AUFB">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFB)))" />
				                                </xsl:when>
				                                <xsl:when test="../AUF/AUFN">
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(../AUF/AUFN)))" />
				                                </xsl:when>
				                                <xsl:otherwise>
				                                    <xsl:value-of
								select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(./AUTN)))" />
				                                </xsl:otherwise>
				                            </xsl:choose>
			                            </xsl:variable>
			                            <xsl:choose>
			                                <xsl:when test="./AUTS">
			                                    <xsl:value-of
								select="concat($author, '-', arco-fn:urify(normalize-space(./AUTS)))" />
			                                </xsl:when>
			                                <xsl:when test="../AUF/AUFS">
			                                    <xsl:value-of
								select="concat($author, '-', arco-fn:urify(normalize-space(../AUF/AUFS)))" />
			                                </xsl:when>
			                                <xsl:otherwise>
			                                    <xsl:value-of
								select="$author" />
			                                </xsl:otherwise>
			                            </xsl:choose>
		                    	</xsl:attribute>
						</arco-core:hasAuthor>
					</xsl:when>
					<xsl:otherwise>
					<xsl:for-each select="./AUTW">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
			                	</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:if>
				</xsl:for-each>
				<!-- responsibility (F and FF) -->
				<xsl:for-each select="schede/*/PD/PDF">
					<arco-cd:hasResponsibility>
						<xsl:attribute name="rdf:resource">
	                        <xsl:value-of
							select="concat($NS, 'Responsibility/', $itemURI, '-', position())" />
	                    </xsl:attribute>
                    </arco-cd:hasResponsibility>
				</xsl:for-each>
				<!-- inventory -->
				<xsl:for-each select="schede/*/UB/INV">
					<xsl:if test="./*">
						<arco-cd:hasInventory>
							<xsl:attribute name="rdf:resource">
		                			<xsl:value-of
								select="concat($NS, 'Inventory/', $itemURI, '-', position())" />
		                		</xsl:attribute>
						</arco-cd:hasInventory>
					</xsl:if>
				</xsl:for-each>
				<!-- commission -->
				<xsl:for-each select="schede/*/AU/CMM">
					<arco-dd:hasCommission>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'Commission/', $itemURI, '-', position())" />
	                        </xsl:attribute>
					</arco-dd:hasCommission>
				</xsl:for-each>
				<xsl:for-each select="schede/*/AU/EDT">
					<xsl:if test="./EDTN">
						<arco-cd:hasEdition>
							<xsl:attribute name="rdf:resource">
	                                <xsl:choose>
	                                    <xsl:when test="./EDTE and ./EDTL">
	                                        <xsl:value-of
								select="concat($NS, 'Edition/', $itemURI, '-', arco-fn:urify(normalize-space(./EDTE)), '-', arco-fn:urify(normalize-space(./EDTL)))" />
	                                    </xsl:when>
	                                    <xsl:when test="./EDTE">
	                                        <xsl:value-of
								select="concat($NS, 'Edition/', $itemURI, '-', arco-fn:urify(normalize-space(./EDTE)))" />
	                                    </xsl:when>
	                                    <xsl:when test="./EDTL">
	                                        <xsl:value-of
								select="concat($NS, 'Edition/', $itemURI, '-', arco-fn:urify(normalize-space(./EDTL)))" />
	                                    </xsl:when>
	                                    <xsl:otherwise>
	                                        <xsl:value-of
								select="concat($NS, 'Edition/', $itemURI, '-', position())" />
	                                    </xsl:otherwise>
	                                </xsl:choose>
	                            </xsl:attribute>
						</arco-cd:hasEdition>
					</xsl:if>
				</xsl:for-each>
				<!-- has dating -->
				<xsl:for-each select="schede/*/DT">
					<xsl:choose>
						<xsl:when test="./* and (not(./DTP) or ./DTP='intero bene' or ./DTP='integrale' or ./DTP='tutta' or ./DTP='totale') or (starts-with(lower-case(normalize-space(./DTP)), 'nr')) or (starts-with(lower-case(normalize-space(./DTP)), 'n.r')) or (starts-with(lower-case(normalize-space(./DTP)), 'intero')) or (starts-with(lower-case(normalize-space(./DTP)), 'intera')) or (starts-with(lower-case(normalize-space(./DTP)), 'esemplar'))">
							<arco-cd:hasDating>
								<xsl:attribute name="rdf:resource">
			                            <xsl:value-of
									select="concat($NS, 'Dating/', $itemURI, '-', position())" />
			                        </xsl:attribute>
							</arco-cd:hasDating>
						</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="./DTP">
								<arco-core:hasPart>
									<xsl:attribute name="rdf:resource">
				                				<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
				                	</xsl:attribute>
								</arco-core:hasPart>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<!-- has dating for A norm -->
				<xsl:for-each select="schede/A/RE">
					<xsl:choose>
						<xsl:when test="./* and (not(./REN/RENR) or ./REN/RENR='intero bene' or ./REN/RENR='integrale' or ./REN/RENR='tutta' or ./REN/RENR='totale') or (starts-with(lower-case(normalize-space(./REN/RENR)), 'nr')) or (starts-with(lower-case(normalize-space(./REN/RENR)), 'n.r')) or (starts-with(lower-case(normalize-space(./REN/RENR)), 'intero')) or (starts-with(lower-case(normalize-space(./REN/RENR)), 'intera')) or (starts-with(lower-case(normalize-space(./REN/RENR)), 'esemplar'))">
							<arco-cd:hasDating>
								<xsl:attribute name="rdf:resource">
			                            <xsl:value-of
									select="concat($NS, 'Dating/', $itemURI, '-', position())" />
			                        </xsl:attribute>
							</arco-cd:hasDating>
						</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="./REN/RENR">
								<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
				                				<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
				                	</xsl:attribute>
								</arco-core:hasPart>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				
				<!-- Measurement -->
				<xsl:for-each select="schede/*/MT/MIS">
					<xsl:choose>
						<xsl:when test="($sheetVersion='4.00_ICCD0' or $sheetVersion='4.00') and ./MISP and not(lower-case(normalize-space(./MISP))='intero bene' or lower-case(normalize-space(./MISP))='integrale' or lower-case(normalize-space(./MISP))='tutta' or lower-case(normalize-space(./MISP))='totale' or (starts-with(lower-case(normalize-space(./MISP)), 'nr')) or (starts-with(lower-case(normalize-space(./MISP)), 'n.r')))">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
				              		<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(./MISP)))" />
				                </xsl:attribute>
							</arco-core:hasPart>
						</xsl:when>
						<xsl:when test="$sheetType='F' and ./MISO and not(lower-case(normalize-space(./MISO))='intero bene' or lower-case(normalize-space(./MISO))='integrale' or lower-case(normalize-space(./MISO))='tutta' or lower-case(normalize-space(./MISO))='totale' or (starts-with(lower-case(normalize-space(./MISO)), 'nr')) or (starts-with(lower-case(normalize-space(./MISO)), 'n.r')))">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
				              		<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(./MISO)))" />
				                </xsl:attribute>
							</arco-core:hasPart>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="measurement-collection">
								<xsl:choose>
									<xsl:when test="($sheetVersion='4.00_ICCD0' or $sheetVersion='4.00') and ./MISP" >
										<xsl:value-of
												select="concat($NS, 'MeasurementCollection/', $itemURI, '-', arco-fn:urify(normalize-space(./MISP)))" />
									</xsl:when>
									<xsl:when test="($sheetVersion='4.00_ICCD0' or $sheetVersion='4.00') and not(./MISP)" >
										<xsl:value-of
												select="concat($NS, 'MeasurementCollection/', $itemURI)" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
												select="concat($NS, 'MeasurementCollection/', $itemURI, '-', position())" />
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<arco-dd:hasMeasurementCollection>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="$measurement-collection" />
				              	</xsl:attribute>
							</arco-dd:hasMeasurementCollection>
							
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<!-- intervention (CO/RST) -->
				<xsl:for-each select="schede/*/CO/RST">
					<xsl:choose>
						<xsl:when test="./* and (not(./RSTP) or ./RSTP='intero bene' or ./RSTP='integrale' or ./RSTP='tutta' or ./RSTP='totale') or (starts-with(lower-case(normalize-space(./RSTP)), 'nr')) or (starts-with(lower-case(normalize-space(./RSTP)), 'n.r')) or (starts-with(lower-case(normalize-space(./RSTP)), 'intero')) or (starts-with(lower-case(normalize-space(./RSTP)), 'intera')) or (starts-with(lower-case(normalize-space(./RSTP)), 'esemplar'))">
							<arco-cd:hasIntervention>
								<xsl:choose>
									<xsl:when test="contains(normalize-space(lower-case(./RSTI)), 'consolidamento') or contains(normalize-space(lower-case(./RSTI)), 'controllo microclimatico') or contains(normalize-space(lower-case(./RSTI)), 'trattamento biocida-disinfestazione') or contains(normalize-space(lower-case(./RSTI)), 'rimozione di elementi non originali') or contains(normalize-space(lower-case(./RSTI)), 'pulitura meccanica') or contains(normalize-space(lower-case(./RSTI)), 'pulitura chimica') or contains(normalize-space(lower-case(./RSTI)), 'protezione finale') or contains(normalize-space(lower-case(./RSTI)), 'riadesione parti') or contains(normalize-space(lower-case(./RSTI)), 'trattamento parti metalliche')">
										<xsl:attribute name="rdf:resource">
											<xsl:value-of select="concat($NS, 'ConservationIntervention/', $itemURI, '-conservation-intervention-', position())" />
										</xsl:attribute>
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="rdf:resource">
											<xsl:value-of select="concat($NS, 'Intervention/', $itemURI, '-intervention-', position())" />
										</xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
							</arco-cd:hasIntervention>
						</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="./RSTP">
								<arco-core:hasPart>
									<xsl:attribute name="rdf:resource">
				                				<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
				                	</xsl:attribute>
								</arco-core:hasPart>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<!-- intervention (RS/RST) -->
				<xsl:for-each select="schede/*/RS/RST">
					<xsl:choose>
						<xsl:when test="./* and $sheetType='A' and (not(./RSTR) or ./RSTR='intero bene' or ./RSTR='integrale' or ./RSTR='tutta' or ./RSTR='totale') or (starts-with(lower-case(normalize-space(./RSTR)), 'nr')) or (starts-with(lower-case(normalize-space(./RSTR)), 'n.r')) or (starts-with(lower-case(normalize-space(./RSTR)), 'intero')) or (starts-with(lower-case(normalize-space(./RSTR)), 'intera')) or (starts-with(lower-case(normalize-space(./RSTR)), 'esemplar'))">
							<arco-cd:hasIntervention>
								<xsl:attribute name="rdf:resource">
											<xsl:value-of select="concat($NS, 'ConservationIntervention/', $itemURI, '-conservation-intervention-', position())" />
										</xsl:attribute>
							</arco-cd:hasIntervention>
						</xsl:when>
						<xsl:when test="$sheetType='A'">
						<xsl:for-each select="./RSTR">
								<arco-core:hasPart>
									<xsl:attribute name="rdf:resource">
				                				<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
				                	</xsl:attribute>
								</arco-core:hasPart>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="./*">
							<arco-cd:hasIntervention>
								<xsl:attribute name="rdf:resource">
											<xsl:value-of select="concat($NS, 'ConservationIntervention/', $itemURI, '-conservation-intervention-', position())" />
										</xsl:attribute>
							</arco-cd:hasIntervention>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
				<!-- member of collection -->
				<xsl:for-each select="schede/*/UB/COL">
					<xsl:if test="./*">
						<arco-cd:isMemberOfCollection>
							<xsl:attribute name="rdf:resource">
		                            <xsl:value-of
								select="concat($NS, 'CollectionMembership/', $itemURI, '-collection-membership-', position())" />
		                        </xsl:attribute>
						</arco-cd:isMemberOfCollection>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="schede/*/CO/STC">
				<xsl:choose>
					<xsl:when test="./* and (not(./STCP) or ./REIP='intero bene' or ./STCP='integrale' or ./REIP='tutta' or ./STCP='totale') or (starts-with(lower-case(normalize-space(./STCP)), 'nr')) or (starts-with(lower-case(normalize-space(./STCP)), 'n.r')) or (starts-with(lower-case(normalize-space(./STCP)), 'intero')) or (starts-with(lower-case(normalize-space(./STCP)), 'intera')) or (starts-with(lower-case(normalize-space(./STCP)), 'esemplar'))">
						<arco-dd:hasConservationStatus>
							<xsl:attribute name="rdf:resource">
		                            <xsl:value-of
								select="concat($NS, 'ConservationStatus/', $itemURI, '-conservation-status-', position())" />
		                        </xsl:attribute>
						</arco-dd:hasConservationStatus>
					</xsl:when>
					<xsl:otherwise>
					<xsl:for-each select="./STCP">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
			                	</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:for-each>
				<xsl:if test="schede/*/CO/STP">
					<arco-dd:proposedIntervention>
						<xsl:value-of select="normalize-space(schede/*/CO/STP)" />
					</arco-dd:proposedIntervention>
				</xsl:if>
				<xsl:if test="schede/*/CO/STD">
					<arco-dd:storageConditions>
						<xsl:value-of select="normalize-space(schede/*/CO/STD)" />
					</arco-dd:storageConditions>
				</xsl:if>
				<!-- heritage protection agency -->
				<xsl:if test="schede/*/CD/ECP">
					<arco-core:hasAgentRole>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'AgentRole/', $itemURI, '-heritage-protection-agency')" />
	                        </xsl:attribute>
					</arco-core:hasAgentRole>
					<arco-core:hasHeritageProtectionAgency>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(schede/*/CD/ECP)))" />
	                        </xsl:attribute>
					</arco-core:hasHeritageProtectionAgency>
				</xsl:if>
				<!-- cataloguing agency -->
				<xsl:if test="schede/*/CD/ESC">
					<arco-core:hasAgentRole>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'AgentRole/', $itemURI, '-cataloguing-agency')" />
	                        </xsl:attribute>
					</arco-core:hasAgentRole>
					<arco-core:hasCataloguingAgency>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(schede/*/CD/ESC)))" />
	                        </xsl:attribute>
					</arco-core:hasCataloguingAgency>
				</xsl:if>
				<!-- proponent agency -->
				<xsl:if test="schede/*/CD/EPR">
					<arco-core:hasAgentRole>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'AgentRole/', $itemURI, '-proponent-agency')" />
	                        </xsl:attribute>
					</arco-core:hasAgentRole>
					<arco-cd:hasProponentAgency>
						<xsl:attribute name="rdf:resource">
	                            <xsl:value-of
							select="concat($NS, 'Agent/', arco-fn:urify(normalize-space(schede/*/CD/EPR)))" />
	                        </xsl:attribute>
					</arco-cd:hasProponentAgency>
				</xsl:if>
				<!-- Type of context for LC -->
				<xsl:for-each select="schede/*/LC/PVZ">
					<arco-location:hasTypeOfContext>
						<xsl:attribute name="rdf:resource">
	                            <xsl:choose>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto urbano'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Urban'" />
	                                </xsl:when>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto suburbano'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Suburban'" />
	                                </xsl:when>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto territoriale'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Territorial'" />
	                                </xsl:when>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto subacqueo'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Underwater'" />
	                                </xsl:when>
	                                <xsl:otherwise>
	                                    <xsl:value-of
							select="concat($NS, 'TypeOfContext/', arco-fn:urify(normalize-space(.)))" />
	                                </xsl:otherwise>
	                            </xsl:choose>
	                        </xsl:attribute>
					</arco-location:hasTypeOfContext>
				</xsl:for-each>
				<!-- Type of context for LA -->
				<xsl:for-each select="schede/*/LA/PRZ">
					<arco-location:hasTypeOfContext>
						<xsl:attribute name="rdf:resource">
	                            <xsl:choose>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto urbano'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Urban'" />
	                                </xsl:when>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto suburbano'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Suburban'" />
	                                </xsl:when>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto territoriale'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Territorial'" />
	                                </xsl:when>
	                                <xsl:when
							test="lower-case(normalize-space(.)) = 'contesto subacqueo'">
	                                    <xsl:value-of
							select="'https://w3id.org/arco/location/Underwater'" />
	                                </xsl:when>
	                                <xsl:otherwise>
	                                    <xsl:value-of
							select="concat($NS, 'TypeOfContext/', arco-fn:urify(normalize-space(.)))" />
	                                </xsl:otherwise>
	                            </xsl:choose>
	                        </xsl:attribute>
					</arco-location:hasTypeOfContext>
				</xsl:for-each>
				<!-- Acquisition of cultural property -->
				<xsl:for-each select="schede/*/TU/ACQ">
					<arco-cd:hasAcquisition>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'Acquisition/', $itemURI, '-acquisition-', position())" />
	                		</xsl:attribute>
					</arco-cd:hasAcquisition>
				</xsl:for-each>
				<!-- Change of availability of cultural property -->
				<xsl:for-each select="schede/*/TU/ALN">
					<arco-cd:hasChangeOfAvailability>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'ChangeOfAvailability/', $itemURI, '-change-of-availability')" />
	                		</xsl:attribute>
					</arco-cd:hasChangeOfAvailability>
				</xsl:for-each>
				<!-- Photographic Documentation of cultural property -->
				<xsl:for-each select="schede/*/DO/FTA">
					<arco-cd:hasDocumentation>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'PhotographicDocumentation/', $itemURI, '-photographic-documentation-', position())" />
	                		</xsl:attribute>
					</arco-cd:hasDocumentation>
				</xsl:for-each>
				<!-- Graphic or cartographic Documentation of cultural property -->
				<xsl:for-each select="schede/*/DO/DRA">
					<arco-cd:hasDocumentation>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'GraphicOrCartographicDocumentation/', $itemURI, '-graphic-cartographic-documentation-', position())" />
	                		</xsl:attribute>
					</arco-cd:hasDocumentation>
				</xsl:for-each>
				<!-- Film Documentation of cultural property -->
				<xsl:for-each select="schede/*/DO/VDC">
					<arco-cd:hasDocumentation>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'FilmDocumentation/', $itemURI, '-film-documentation-', position())" />
	                		</xsl:attribute>
					</arco-cd:hasDocumentation>
				</xsl:for-each>
				<!-- Audio Documentation of cultural property -->
				<xsl:for-each select="schede/*/DO/REG">
					<arco-cd:hasDocumentation>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'AudioDocumentation/', $itemURI, '-audio-documentation-', position())" />
	                		</xsl:attribute>
					</arco-cd:hasDocumentation>
				</xsl:for-each>
				<!-- Sources and Documents of cultural property -->
				<xsl:for-each select="schede/*/DO/FNT">
					<arco-cd:hasDocumentation>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'SourceAndDocument/', $itemURI, '-source-document-', position())" />
	                		</xsl:attribute>
					</arco-cd:hasDocumentation>
				</xsl:for-each>
				<!-- Bibliography of cultural property -->
				<xsl:for-each select="schede/*/DO/BIB">
					<arco-cd:hasBibliography>
						<xsl:attribute name="rdf:resource">
	                			<xsl:value-of
							select="concat($NS, 'Bibliography/', $itemURI, '-bibliography-', position())" />
	                		</xsl:attribute>
					</arco-cd:hasBibliography>
				</xsl:for-each>
				<!-- Geometry of cultural property -->
				<xsl:choose>
					<!-- if does not exist the element MTAP we refer the geometry directly to the cultural property.
					Otherwise: 
					(i) we generate a number of parts (i.e. the values for MTAP elements) - both here and in the rule below;
					(ii) we associate each geometry value in MTAP to generated parts - see rule below;
					(iii) we associate the cultural property to its parts - here.
					 -->
					<xsl:when test="not(schede/*/MT/MTA/MTAP) or (starts-with(lower-case(normalize-space(schede/*/MT/MTA/MTAP)), 'nr')) or (starts-with(lower-case(normalize-space(schede/*/MT/MTA/MTAP)), 'n.r'))">
						<xsl:for-each select="schede/*/GP">
							<clvapit:hasGeometry>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'Geometry/', $itemURI, '-geometry-point-', position())" />
			                			</xsl:attribute>
							</clvapit:hasGeometry>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="schede/*/GP">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', position())" />
			                			</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:for-each select="schede/*/GA">
					<clvapit:hasGeometry>
						<xsl:attribute name="rdf:resource">
	                				<xsl:value-of
							select="concat($NS, 'Geometry/', $itemURI, '-geometry-polygon-', position())" />
	                			</xsl:attribute>
					</clvapit:hasGeometry>
				</xsl:for-each>
				<xsl:for-each select="schede/*/GL">
					<clvapit:hasGeometry>
						<xsl:attribute name="rdf:resource">
	                				<xsl:value-of
							select="concat($NS, 'Geometry/', $itemURI, '-geometry-line-', position())" />
	                			</xsl:attribute>
					</clvapit:hasGeometry>
				</xsl:for-each>
				<xsl:for-each select="schede/*/GE">
					<clvapit:hasGeometry>
						<xsl:attribute name="rdf:resource">
	                				<xsl:value-of
							select="concat($NS, 'Geometry/', $itemURI, '-geometry-', position())" />
	                			</xsl:attribute>
					</clvapit:hasGeometry>
				</xsl:for-each>


				<xsl:for-each select="schede/*/*/SGT/SGTI">
					<xsl:if
						test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
						<arco-cd:subject>
							<xsl:value-of select="normalize-space(.)" />
						</arco-cd:subject>
						<arco-cd:hasSubject>
							<xsl:attribute name="rdf:resource">
	                    		<xsl:value-of
								select="concat($NS, 'Subject/', arco-fn:urify(normalize-space(.)))" />
	                    	</xsl:attribute>
						</arco-cd:hasSubject>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="schede/NU/DA/DES/DESU">
					<xsl:if
						test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
						<arco-cd:subject>
							<xsl:value-of select="normalize-space(.)" />
						</arco-cd:subject>
						<arco-cd:hasSubject>
							<xsl:attribute name="rdf:resource">
	                    		<xsl:value-of
								select="concat($NS, 'Subject/', arco-fn:urify(normalize-space(.)))" />
	                    	</xsl:attribute>
						</arco-cd:hasSubject>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="schede/*/DA/AID/AIDI">
					<xsl:if
						test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
						<arco-cd:subject>
							<xsl:value-of select="normalize-space(.)" />
						</arco-cd:subject>
						<arco-cd:hasSubject>
							<xsl:attribute name="rdf:resource">
	                    		<xsl:value-of
								select="concat($NS, 'Subject/', arco-fn:urify(normalize-space(.)))" />
	                    	</xsl:attribute>
						</arco-cd:hasSubject>
					</xsl:if>
				</xsl:for-each>
				<xsl:if
					test="schede/*/DA/DES/DESI and not(lower-case(normalize-space(schede/*/DA/DES/DESI))='nr' or lower-case(normalize-space(schede/*/DA/DES/DESI))='n.r.' or lower-case(normalize-space(schede/*/DA/DES/DESI))='nr (recupero pregresso)')">
					<xsl:for-each select="schede/*/DA/DES/DESI">
						<arco-cd:iconclassCode>
							<xsl:value-of select="normalize-space(.)" />
						</arco-cd:iconclassCode>
					</xsl:for-each>
				</xsl:if>
				<xsl:for-each select="schede/*/DA/AID/AIDC">
				<xsl:if
					test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
					<arco-cd:iconclassCode>
						<xsl:value-of select="normalize-space(.)" />
					</arco-cd:iconclassCode>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="schede/*/OG/SGT/SGTT">
				<xsl:if
					test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
					<arco-cd:title>
						<xsl:value-of select="normalize-space(.)" />
					</arco-cd:title>
					<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
				</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="schede/*/DA/AID/AIDT">
				<xsl:if
					test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
					<arco-cd:title>
						<xsl:value-of select="normalize-space(.)" />
					</arco-cd:title>
					<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
				</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="schede/*/DA/AID/AIDN">
				<xsl:if
					test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
					<arco-cd:alternativeTitle>
						<xsl:value-of select="normalize-space(.)" />
					</arco-cd:alternativeTitle>
					<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
					</xsl:if>
				</xsl:for-each>
				<!-- proper title -->
				<xsl:for-each select="schede/*/OG/SGT/SGTP">
				<xsl:if
					test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
					<arco-cd:properTitle>
						<xsl:value-of select="normalize-space(.)" />
					</arco-cd:properTitle>
					<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
					</xsl:if>
				</xsl:for-each>
				<xsl:if
					test="not(lower-case(normalize-space(schede/*/SG/SGL/SGLT))='nr' or lower-case(normalize-space(schede/*/SG/SGL/SGLT))='n.r.' or lower-case(normalize-space(schede/*/SG/SGL/SGLT))='nr (recupero pregresso)')">
					<xsl:for-each select="schede/*/SG/SGL/SGLT">
						<arco-cd:properTitle>
							<xsl:value-of select="normalize-space(.)" />
						</arco-cd:properTitle>
						<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
					</xsl:for-each>
				</xsl:if>
				<!-- parallel title -->
				<xsl:for-each select="schede/*/OG/SGT/SGTR">
				<xsl:if
					test="not(starts-with(lower-case(normalize-space(.)), 'nr')) and not(starts-with(lower-case(normalize-space(.)), 'n.r'))">
					<arco-cd:parallelTitle>
						<xsl:value-of select="normalize-space(.)" />
					</arco-cd:parallelTitle>
					<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
					</xsl:if>
				</xsl:for-each>
				<xsl:if
					test="not(lower-case(normalize-space(schede/*/SG/SGL/SGLL))='nr' or lower-case(normalize-space(schede/*/SG/SGL/SGLL))='n.r.' or lower-case(normalize-space(schede/*/SG/SGL/SGLL))='nr (recupero pregresso)')">
					<xsl:for-each select="schede/*/SG/SGL/SGLL">
						<arco-cd:parallelTitle>
							<xsl:value-of select="normalize-space(.)" />
						</arco-cd:parallelTitle>
						<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
					</xsl:for-each>
				</xsl:if>
				<!-- attributed title -->
				<xsl:if
					test="not(lower-case(normalize-space(schede/*/SG/SGL/SGLA))='nr' or lower-case(normalize-space(schede/*/SG/SGL/SGLA))='n.r.' or lower-case(normalize-space(schede/*/SG/SGL/SGLA))='nr (recupero pregresso)')">
					<xsl:for-each select="schede/*/SG/SGL/SGLA">
						<arco-cd:attributedTitle>
							<xsl:value-of select="normalize-space(.)" />
						</arco-cd:attributedTitle>
						<arco-cd:hasTitle>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'Title/', $itemURI, '-', arco-fn:urify(normalize-space(.)))" />
						</xsl:attribute>
					</arco-cd:hasTitle>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with preparatory or final work (RO/ROF) -->
				<xsl:if test="schede/*/RO/ROF">
					<xsl:for-each select="schede/*/RO/ROF">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-preparatory-final-work-', position())" />
							</xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with copy (RO/COP) -->
				<xsl:if test="schede/*/RO/COP or schede/*/RO/CRF/CRFT='copia'">
					<xsl:for-each select="schede/*/RO/COP | schede/*/RO/CRF">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-copy-', position())" />
							</xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with a generic derivated work (if RO/CRF/CRFT != 'replica' or 'contraffazione' or 'controtipo' or 'reimpiego' or 'copia') -->
				<xsl:if test="schede/*/RO/CRF and not(schede/*/RO/CRF/CRFT='copia' or schede/*/RO/CRF/CRFT='contraffazione' or schede/*/RO/CRF/CRFT='controtipo' or schede/*/RO/CRF/CRFT='replica' or schede/*/RO/CRF/CRFT='reimpiego')">
					<xsl:for-each select="schede/*/RO/CRF">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-derivated-work-', position())" />
							</xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with a particular type of derivated work: forgery -->
				<xsl:if test="schede/*/RO/CRF/CFRT='contraffazione'">
					<xsl:for-each select="schede/*/RO/CRF">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-forgery-', position())" />
							</xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with a particular type of derivated work: facsimile -->
				<xsl:if test="schede/*/RO/CRF/CFRT='controtipo'">
					<xsl:for-each select="schede/*/RO/CRF">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-facsimile-', position())" />
							</xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with a particular type of derivated work: same author copy -->
				<xsl:if test="schede/*/RO/CRF/CFRT='replica'">
					<xsl:for-each select="schede/*/RO/CRF">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
								<xsl:value-of select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-same-author-copy-', position())" />
							</xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with a particular type of derivated work: reuse -->
				<xsl:if test="schede/*/RO/REI or schede/*/RO/RIU or schede/*/RO/CRF/CFRT='reimpiego'">
					<xsl:for-each select="schede/*/RO/REI | schede/*/RO/RIU | schede/*/RO/CRF">
					<xsl:choose>
						<xsl:when test="./* and (not(./REIP) or ./REIP='intero bene' or ./REIP='integrale' or ./REIP='tutta' or ./REIP='totale') or (starts-with(lower-case(normalize-space(./REIP)), 'nr')) or (starts-with(lower-case(normalize-space(./REIP)), 'n.r')) or (starts-with(lower-case(normalize-space(./REIP)), 'intero')) or (starts-with(lower-case(normalize-space(./REIP)), 'intera')) or (starts-with(lower-case(normalize-space(./REIP)), 'esemplar'))">
							<arco-cd:hasRelatedWorkSituation>
								<xsl:attribute name="rdf:resource">
			                            <xsl:value-of
									select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-reuse-', position())" />
			                        </xsl:attribute>
							</arco-cd:hasRelatedWorkSituation>
						</xsl:when>
						<xsl:when test="../RIU">
							<arco-cd:hasRelatedWorkSituation>
								<xsl:attribute name="rdf:resource">
			                            <xsl:value-of
									select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-reuse-', position())" />
			                        </xsl:attribute>
							</arco-cd:hasRelatedWorkSituation>
						</xsl:when>
						<xsl:when test="../CRF">
							<arco-cd:hasRelatedWorkSituation>
								<xsl:attribute name="rdf:resource">
			                            <xsl:value-of
									select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-reuse-', position())" />
			                        </xsl:attribute>
							</arco-cd:hasRelatedWorkSituation>
						</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="./REIP">
								<arco-core:hasPart>
									<xsl:attribute name="rdf:resource">
				                				<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
				                	</xsl:attribute>
								</arco-core:hasPart>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:for-each>
				</xsl:if>
				<!-- relation with a particular type of derivated work: print in publication (S) -->
				<xsl:if test="schede/*/RO/ADL">
					<xsl:for-each select="schede/*/RO/ADL">
						<arco-cd:hasRelatedWorkSituation>
							<xsl:attribute name="rdf:resource">
			                            <xsl:value-of
									select="concat($NS, 'RelatedWorkSituation/', $itemURI, '-print-in-publication-', position())" />
			                        </xsl:attribute>
						</arco-cd:hasRelatedWorkSituation>
					</xsl:for-each>
				</xsl:if>
				<!-- name in time (OG/OGD) -->
				<xsl:for-each select="schede/*/OG/OGD">
					<arco-dd:hasDesignationInTime>
						<xsl:attribute name="rdf:resource">
                        	<xsl:value-of
							select="concat('https://w3id.org/arco/resource/DesignationInTime/', arco-fn:urify(normalize-space(./OGDN)))" />                      	                            
                        </xsl:attribute>
					</arco-dd:hasDesignationInTime>
				</xsl:for-each>
				<!-- name in time (OG/OGT/OGTN) -->
				<xsl:for-each select="schede/*/OG/OGT/OGTN">
					<arco-dd:hasDesignationInTime>
						<xsl:attribute name="rdf:resource">
                        			<xsl:value-of
							select="concat('https://w3id.org/arco/resource/DesignationInTime/', arco-fn:urify(normalize-space(.)))" />   	                            
                        </xsl:attribute>
					</arco-dd:hasDesignationInTime>
				</xsl:for-each>
				<!-- identifier:uniqueIdentifier - concat of NCTR + NCTN + NCTS available 
					in schede/*/CD/NCT) -->
				<xsl:if test="schede/*/CD/NCT">
					<arco-core:uniqueIdentifier>
						<xsl:value-of
							select="concat(schede/*/CD/NCT/NCTR, schede/*/CD/NCT/NCTN, schede/*/CD/NCT/NCTS)" />
					</arco-core:uniqueIdentifier>
				</xsl:if>
				<!-- NCTR Codice Regione (schede/*/CD/NCT/NCTR) -->
				<xsl:for-each select="schede/*/CD/NCT/NCTR">
					<arco-core:regionIdentifier>
						<xsl:value-of select="." />
					</arco-core:regionIdentifier>
				</xsl:for-each>
				<!-- NCTN Numero catalogo generale (schede/*/CD/NCT/NCTN) -->
				<xsl:for-each select="schede/*/CD/NCT/NCTN">
					<arco-core:catalogueNumber>
						<xsl:value-of select="." />
					</arco-core:catalogueNumber>
				</xsl:for-each>
				<!-- NCTS Suffisso (schede/*/CD/NCT/NCTS) -->
				<xsl:for-each select="schede/*/CD/NCT/NCTS">
					<arco-core:suffix>
						<xsl:value-of select="." />
					</arco-core:suffix>
				</xsl:for-each>
				<!-- finding note (RE/RES) -->
				<xsl:if test="schede/*/RE/RES">
					<arco-cd:findingNote>
						<xsl:value-of select="schede/*/RE/RES" />
					</arco-cd:findingNote>
				</xsl:if>
				<!-- inscription (DA/ISR) -->
				<xsl:if test="schede/*/DA/ISR/*">
					<xsl:for-each select="schede/*/DA/ISR">
						<arco-dd:hasAffixedElement>
							<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Inscription/', $itemURI, '-inscription-', position())" />
								</xsl:attribute>
						</arco-dd:hasAffixedElement>
					</xsl:for-each>
				</xsl:if>
				<!-- affixed element (DA/STM) -->
				<xsl:if test="schede/*/DA/STM/*">
				<xsl:for-each select="schede/*/DA/STM">
					<arco-dd:hasAffixedElement>
						<xsl:choose>
							<xsl:when test="lower-case(normalize-space(./STMC))='timbro'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Stamp/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./STMC))='stemma'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'CoatOfArms/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./STMC))='emblema'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Emblem/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./STMC))='marchio'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Brand/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./STMC))='logo'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Logo/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'AffixedElement/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</arco-dd:hasAffixedElement>
				</xsl:for-each>
				</xsl:if>
				<!-- affixed element (*/LSI) -->
				<xsl:if test="schede/A/*/LSI/*">
				<xsl:for-each select="schede/A/*/LSI/*">
					<arco-dd:hasAffixedElement>
						<xsl:choose>
							<xsl:when test="lower-case(normalize-space(./LSIG))='timbro'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Stamp/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./LSIG))='stemma'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'CoatOfArms/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./LSIG))='emblema'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Emblem/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./LSIG))='marchio'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Brand/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./LSIG))='logo'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Logo/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./LSIG))='lapide'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'HistoricalPlaque/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'AffixedElement/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</arco-dd:hasAffixedElement>
				</xsl:for-each>
				</xsl:if>
				<!-- affixed element (DA/ISE) -->
				<xsl:for-each select="schede/*/DA/ISE">
				<xsl:choose>
					<xsl:when test="./* and (not(./ISER) or ./ISER='intero bene' or ./ISER='integrale' or ./ISER='tutta' or ./ISER='totale') or (starts-with(lower-case(normalize-space(./ISER)), 'nr')) or (starts-with(lower-case(normalize-space(./ISER)), 'n.r')) or (starts-with(lower-case(normalize-space(./ISER)), 'intero')) or (starts-with(lower-case(normalize-space(./ISER)), 'intera')) or (starts-with(lower-case(normalize-space(./ISER)), 'esemplar'))">
							<arco-dd:hasAffixedElement>
						<xsl:choose>
							<xsl:when test="lower-case(normalize-space(./ISED))='timbro'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Stamp/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./ISED))='stemma'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'CoatOfArms/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./ISED))='emblema'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Emblem/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./ISED))='marchio'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Brand/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./ISED))='logo'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Logo/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:when test="lower-case(normalize-space(./ISED))='iscrizione'">
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'Inscription/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="rdf:resource">
									<xsl:value-of select="concat($NS, 'AffixedElement/', $itemURI, '-affixed-element-', position())" />
								</xsl:attribute>
							</xsl:otherwise>
						</xsl:choose>
					</arco-dd:hasAffixedElement>
					</xsl:when>
						<xsl:otherwise>
						<xsl:for-each select="./ISER">
								<arco-core:hasPart>
									<xsl:attribute name="rdf:resource">
				                				<xsl:value-of
										select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
				                	</xsl:attribute>
								</arco-core:hasPart>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<!-- coin issuance (NU) -->
				<xsl:for-each select="schede/*/DA/AUE">
					<arco-cd:hasCoinIssuance>
						<xsl:attribute name="rdf:resource">
							<xsl:value-of select="concat($NS, 'CoinIssuance/', $itemURI, '-issuance-', position())" />
						</xsl:attribute>
					</arco-cd:hasCoinIssuance>
				</xsl:for-each>
				<!-- Use of cultural property -->
                <xsl:if test="not(schede/A/UT or schede/PG/UT)">
	                <xsl:for-each select="schede/*/UT">
	                	<arco-cd:hasUse>
	                		<xsl:attribute name="rdf:resource">
	                			<xsl:value-of select="concat($NS, 'Use/', $itemURI, '-use-', position())" />
	                		</xsl:attribute>
	                	</arco-cd:hasUse>                
	                </xsl:for-each>
                </xsl:if>
                <xsl:if test="schede/*/DA/UTF or schede/*/DA/UTM or schede/*/DA/UTS">
                	<arco-cd:hasUse>
                		<xsl:attribute name="rdf:resource">
	                			<xsl:value-of select="concat($NS, 'Use/', $itemURI, '-use')" />
	                		</xsl:attribute>
                	</arco-cd:hasUse>
                </xsl:if>
                <xsl:for-each select="schede/*/US/USO">
                	<xsl:choose>
					<xsl:when test="./* and (not(./USOR) or ./USOR='intero bene' or ./USOR='integrale' or ./USOR='tutta' or ./USOR='totale') or (starts-with(lower-case(normalize-space(./USOR)), 'nr')) or (starts-with(lower-case(normalize-space(./USOR)), 'n.r')) or (starts-with(lower-case(normalize-space(./USOR)), 'intero')) or (starts-with(lower-case(normalize-space(./USOR)), 'intera')) or (starts-with(lower-case(normalize-space(./USOR)), 'esemplar'))">
						<arco-dd:hasUse>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'Use/', $itemURI, '-historical-use-', position())" />
 	                	</xsl:attribute>
 	                </arco-dd:hasUse>
					</xsl:when>
					<xsl:otherwise>
					<xsl:for-each select="./USOR">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
			                	</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
                </xsl:for-each>
                <xsl:for-each select="schede/*/US/USA">
                	<xsl:choose>
					<xsl:when test="./* and (not(./USAR) or ./USAR='intero bene' or ./USAR='integrale' or ./USAR='tutta' or ./USAR='totale') or (starts-with(lower-case(normalize-space(./USAR)), 'nr')) or (starts-with(lower-case(normalize-space(./USAR)), 'n.r')) or (starts-with(lower-case(normalize-space(./USAR)), 'intero')) or (starts-with(lower-case(normalize-space(./USAR)), 'intera')) or (starts-with(lower-case(normalize-space(./USAR)), 'esemplar'))">
						<arco-dd:hasUse>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'Use/', $itemURI, '-current-use-', position())" />
 	                	</xsl:attribute>
 	                </arco-dd:hasUse>
					</xsl:when>
					<xsl:otherwise>
					<xsl:for-each select="./USAR">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
			                	</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
                </xsl:for-each>
                <!-- material of cultural property (version 4.00) -->
                <xsl:if test="not(starts-with(lower-case(normalize-space(schede/*/MT/MTC/MTCM)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/MT/MTC/MTCM)), 'n.r'))">
               <xsl:for-each select="schede/*/MT/MTC/MTCM">
 	            <xsl:choose>
					<xsl:when test="(not(../MTCP) or ../MTCP='intero bene' or ../MTCP='integrale' or ../MTCP='tutta' or ../MTCP='totale') or (starts-with(lower-case(normalize-space(../MTCP)), 'nr')) or (starts-with(lower-case(normalize-space(../MTCP)), 'n.r')) or (starts-with(lower-case(normalize-space(../MTCP)), 'intero')) or (starts-with(lower-case(normalize-space(../MTCP)), 'intera')) or (starts-with(lower-case(normalize-space(../MTCP)), 'esemplar'))">
						<arco-dd:hasTechnicalDetailOccurrence>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-material-', position())" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
					</xsl:when>
					<xsl:otherwise>
					<xsl:for-each select="../MTCP">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
			                	</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:for-each>
				</xsl:if>
				<!-- material of cultural property (VeAC) -->
				<xsl:if test="not(starts-with(lower-case(normalize-space(schede/VeAC/MT/MTC/MTCF)), 'nr'))">
				<xsl:for-each select="schede/VeAC/MT/MTC/MTCF">
					<arco-dd:hasTechnicalDetailOccurrence>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-material-', position())" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
 	             </xsl:for-each>
 	             </xsl:if>
                 <!-- technique of cultural property (4.00) --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/*/MT/MTC/MTCM)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/MT/MTC/MTCM)), 'n.r'))">
                 <xsl:for-each select="schede/*/MT/MTC/MTCT">
                 	 <xsl:choose>
                 	 <xsl:when test="$sheetType='VeAC'">
						<arco-dd:hasTechnicalDetailOccurrence>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-technique-', position())" />
 	                	</xsl:attribute>
 	                	</arco-dd:hasTechnicalDetailOccurrence>
					</xsl:when>
					<xsl:when test="(not(../MTCP) or ../MTCP='intero bene' or ../MTCP='integrale' or ../MTCP='tutta' or ../MTCP='totale') or (starts-with(lower-case(normalize-space(../MTCP)), 'nr')) or (starts-with(lower-case(normalize-space(../MTCP)), 'n.r')) or (starts-with(lower-case(normalize-space(../MTCP)), 'intero')) or (starts-with(lower-case(normalize-space(../MTCP)), 'intera')) or (starts-with(lower-case(normalize-space(../MTCP)), 'esemplar'))">
						<arco-dd:hasTechnicalDetailOccurrence>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-technique-', position())" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
					</xsl:when>
					<xsl:otherwise>
					<xsl:for-each select="../MTCP">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of
									select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
			                	</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
                 </xsl:for-each>
                 </xsl:if>
                 <!-- materialOrTechnique of cultural property (previous versions) -->
                 <xsl:if test="not(schede/*/MT/MTC/*) and (not(starts-with(lower-case(normalize-space(schede/*/MT/MTC)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/MT/MTC)), 'n.r')))">
                 	<xsl:for-each select="schede/*/MT/MTC">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-material-technique-', position())" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
 	               </xsl:for-each>
                 </xsl:if>
                 <!-- shape of cultural property --> 
                 <xsl:if test="schede/*/MT/FRM and not(schede/F/MT/FRM)">
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/*/MT/FRM)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/MT/FRM)), 'n.r'))">
                 	<xsl:for-each select="schede/*/MT/FRM">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-shape')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
 	               </xsl:for-each>
 	               </xsl:if>
                 </xsl:if>
                 <!-- filigree of cultural property --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/*/MT/FIL)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/*/MT/FIL)), 'n.r'))">
                 <xsl:for-each select="schede/*/MT/FIL">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-filigree')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
 	              </xsl:for-each>
 	              </xsl:if>
                 <!-- file format of photograph (F) --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCF)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCF)), 'n.r'))">
                 <xsl:for-each select="schede/F/MT/FVC/FVCF">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-file-format')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:for-each>
                 </xsl:if>
                 <!-- photo size of photograph (F) --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/F/MT/FRM)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/FRM)), 'n.r'))">
                 <xsl:for-each select="schede/F/MT/FRM">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-photo-size')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:for-each>
                 </xsl:if>
                 <!-- photo program of photograph (F) --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCP)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCP)), 'n.r'))">
					<xsl:for-each select="schede/F/MT/FVC/FVCP">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-photo-program')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:for-each>
                 </xsl:if>
                 <!-- storage method and colour depth of photograph (F) --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCC)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCC)), 'n.r'))">
                 <xsl:for-each select="schede/F/MT/FVC/FVCC">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-storage-method-colour-depth')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:for-each>
                 </xsl:if>
                 <!-- resolution of photograph (F) --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCU)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCU)), 'n.r'))">
                 <xsl:for-each select="schede/F/MT/FVC/FVCU">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-resolution')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:for-each>
                 </xsl:if>
                 <!-- pixel dimension of photograph (F) --> 
                 <xsl:if test="not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCM)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/FVC/FVCM)), 'n.r'))">
                 <xsl:for-each select="schede/F/MT/FVC/FVCM">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-pixel-dimension-', position())" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:for-each>
                 </xsl:if>
                 <!-- mass storage of photograph (F) --> 
                 <xsl:if test="schede/F/MT/FVM and (not(starts-with(lower-case(normalize-space(schede/F/MT/FVM)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/FVM)), 'n.r')))">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-mass-storage')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:if>
                 <!-- colour of photograph (F) --> 
                 <xsl:if test="schede/F/MT/MTX and (not(starts-with(lower-case(normalize-space(schede/F/MT/MTX)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/F/MT/MTX)), 'n.r')))">
                 	<arco-dd:hasTechnicalDetailOccurrence>
 	                	<xsl:attribute name="rdf:resource">
 	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-photo-colour')" />
 	                	</xsl:attribute>
 	                </arco-dd:hasTechnicalDetailOccurrence>
                 </xsl:if>
                 <!-- digital photo note (F) -->
                 <xsl:if test="schede/F/MT/FVC/FVCV or schede/F/MT/FVC/FVCN">
                 	<arco-dd:digitalPhotographNote>
                 		<xsl:choose>
                 			<xsl:when test="schede/F/MT/FVC/FVCV">
                 				<xsl:value-of select="schede/F/MT/FVC/FVCV" />
                 			</xsl:when>
                 			<xsl:otherwise>
                 				<xsl:value-of select="schede/F/MT/FVC/FVCN" />
                 			</xsl:otherwise>
                 		</xsl:choose>
                		<xsl:value-of select="normalize-space(schede/F/MT/FVC/FVCV)" />
                	</arco-dd:digitalPhotographNote>
                </xsl:if>
                <!-- colour of garment (VeAC) --> 
                <xsl:if test="schede/VeAC/MT/MTC/MTCC and (not(starts-with(lower-case(normalize-space(schede/VeAC/MT/MTC/MTCC)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/VeAC/MT/MTC/MTCC)), 'n.r')))">
                	<arco-dd:hasTechnicalDetailOccurrence>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-garment-colour')" />
	                	</xsl:attribute>
	                </arco-dd:hasTechnicalDetailOccurrence>
                </xsl:if>
                <!-- analysis of garment (VeAC) --> 
                <xsl:if test="schede/VeAC/MT/MTC/MTCA and (not(starts-with(lower-case(normalize-space(schede/VeAC/MT/MTC/MTCA)), 'nr')) and not(starts-with(lower-case(normalize-space(schede/VeAC/MT/MTC/MTCA)), 'n.r')))">
                	<arco-dd:hasTechnicalDetailOccurrence>
	                	<xsl:attribute name="rdf:resource">
	                		<xsl:value-of select="concat($NS, 'TechnicalDetailOccurrence/', $itemURI, '-garment-analysis')" />
	                	</xsl:attribute>
	                </arco-dd:hasTechnicalDetailOccurrence>
                </xsl:if>
                <!-- Legal situation of cultural property -->
                <xsl:if test="schede/*/TU/CDG">
                	<arco-cd:hasLegalSituation>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of select="concat($NS, 'LegalSituation/', $itemURI, '-legal-situation-', arco-fn:urify(normalize-space(schede/*/TU/CDG/CDGG)))" />
                		</xsl:attribute>
                	</arco-cd:hasLegalSituation>                
                </xsl:if>
                <!-- Export import certification of cultural property -->
                <xsl:for-each select="schede/*/TU/ESP">
                	<arco-cd:hasExportImportCertification>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of select="concat($NS, 'ExportImportCertification/', $itemURI, '-export-import-certification-', position())" />
                		</xsl:attribute>
                	</arco-cd:hasExportImportCertification>                
                </xsl:for-each>
                <!-- Protective measures of cultural property -->
                <xsl:for-each select="schede/*/TU/NVC">
				<xsl:choose>
					<xsl:when test="./* and (not(./NVCP) or ./NVCP='intero bene' or ./NVCP='integrale' or ./NVCP='tutta' or ./NVCP='totale') or (starts-with(lower-case(normalize-space(./NVCP)), 'nr')) or (starts-with(lower-case(normalize-space(./NVCP)), 'n.r')) or (starts-with(lower-case(normalize-space(./NVCP)), 'intero')) or (starts-with(lower-case(normalize-space(./NVCP)), 'intera')) or (starts-with(lower-case(normalize-space(./NVCP)), 'esemplar'))">
						<arco-cd:hasProtectiveMeasure>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of select="concat($NS, 'ProtectiveMeasure/', $itemURI, '-protective-measure-', position())" />
                		</xsl:attribute>
                	</arco-cd:hasProtectiveMeasure>
					</xsl:when>
					<xsl:otherwise>
					<xsl:for-each select="./NVCP">
							<arco-core:hasPart>
								<xsl:attribute name="rdf:resource">
			                				<xsl:value-of select="concat($NS, 'CulturalPropertyPart/', $itemURI, '-part-', arco-fn:urify(normalize-space(.)))" />
			                	</xsl:attribute>
							</arco-core:hasPart>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				</xsl:for-each>
                <!-- Urban planning instrument of cultural property -->
				<xsl:for-each select="schede/*/TU/STU">
                	<arco-cd:hasUrbanPlanningInstrument>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of select="concat($NS, 'UrbanPlanningInstrument/', $itemURI, '-urban-planning-instrument-', position())" />
                		</xsl:attribute>
                	</arco-cd:hasUrbanPlanningInstrument>                
                </xsl:for-each>
                <!-- Other related agents of cultural property -->
                <xsl:for-each select="schede/*/AU/NMC">
                	<arco-cd:hasRelatedAgent>
                		<xsl:attribute name="rdf:resource">
                			<xsl:choose>
                				<xsl:when test="./NMCA">
                					<xsl:value-of select="concat($NS, 'Agent/', $itemURI, '-', arco-fn:urify(normalize-space(./NMCN)), '-', arco-fn:urify(normalize-space(./NMCA)))" />
                				</xsl:when>
                				<xsl:otherwise>
                					<xsl:value-of select="concat($NS, 'Agent/', $itemURI, '-', arco-fn:urify(normalize-space(./NMCN)))" />
                				</xsl:otherwise>
                			</xsl:choose>
                		</xsl:attribute>
                	</arco-cd:hasRelatedAgent>                
                </xsl:for-each>
               <!-- Surveys -->
                <!-- Archaeological field survey of cultural property -->
                <xsl:if test="not(schede/*/RE/RCG/RCGD='0000/00/00' or schede/*/RE/RCG/RCGD='/') and schede/*/RE/RCG/*">
                <xsl:for-each select="schede/*/RE/RCG">
                	<arco-cd:hasSurvey>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of select="concat($NS, 'ArchaeologicalFieldSurvey/', $itemURI, '-survey-', position())" />
                		</xsl:attribute>
                	</arco-cd:hasSurvey>
                </xsl:for-each>
                </xsl:if>
                <!-- Archaeological excavation of cultural property -->
                <xsl:if test="not(schede/*/RE/DSC/DSCD='0000/00/00' or schede/*/RE/DSC/DSCD='/') and schede/*/RE/DSC/*">
                <xsl:for-each select="schede/*/RE/DSC">
                	<arco-cd:hasSurvey>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of select="concat($NS, 'ArchaeologicalExcavation/', $itemURI, '-survey-', position())" />
                		</xsl:attribute>
                	</arco-cd:hasSurvey>
                </xsl:for-each>
                </xsl:if>
                <!-- Inspection of cultural property -->
                <xsl:if test="not(schede/*/CM/ISP/ISPD='0000/00/00' or schede/*/CM/ISP/ISPD='/') and schede/*/CM/ISP/*">
                <xsl:for-each select="schede/*/CM/ISP">
                	<arco-cd:hasSurvey>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of select="concat($NS, 'Inspection/', $itemURI, '-inspection-', position())" />
                		</xsl:attribute>
                	</arco-cd:hasSurvey>
                </xsl:for-each>
                </xsl:if>
			</rdf:Description>
			
			<!-- Images retrieved from the OAI-PMH service of ICCD-MiBAC -->
			
			<xsl:variable name="image-link" select="arco-fn:find-image($item)" />
			<xsl:if test="$image-link != ''">
				<rdf:Description>
					<xsl:attribute name="rdf:about">
                		<xsl:value-of
                			select="$objectOfDescription" />
                	</xsl:attribute>
                	<foaf:image>
                		<xsl:attribute name="rdf:resource">
                			<xsl:value-of
                				select="$image-link" />
                		</xsl:attribute>
                	</foaf:image>
				</rdf:Description>
			</xsl:if>
		</rdf:RDF>

	</xsl:template>
</xsl:stylesheet>