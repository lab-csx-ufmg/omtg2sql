package omtg2sql.omtg.model;
import java.io.IOException;
import java.util.Map;

import omtg2sql.omtg.classes.OMTGClass;
import omtg2sql.omtg.relationships.OMTGRelationship;
import omtg2sql.util.XMLParser;

import org.jdom.JDOMException;


public class OMTGSchemaLoader {

	private XMLParser xmlParser;

	public OMTGSchemaLoader(String xmlfilePath) throws SecurityException, IOException {
		this.xmlParser = new XMLParser(xmlfilePath);
		this.xmlParser.createOMTGSchema(xmlfilePath);
	}

	public OMTGSchema getOMTGModel() throws CloneNotSupportedException {
		Map<String, OMTGClass> classes = xmlParser.getClasses();
		Map<String, OMTGRelationship> relationships = xmlParser.getRelationships();
		return new OMTGSchema(classes, relationships);
	}
}