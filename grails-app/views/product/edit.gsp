<%@ page import="org.pih.warehouse.inventory.InventoryLevel; org.pih.warehouse.product.Product" %>
<html>
	<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="custom" />
        <g:set var="entityName" value="${warehouse.message(code: 'product.label', default: 'Product')}" />

        <g:if test="${productInstance?.id}">
	        <title>${productInstance?.productCode } ${productInstance?.name }</title>
		</g:if>
		<g:else>
	        <title><warehouse:message code="product.add.label" /></title>	
			<content tag="label1"><warehouse:message code="inventory.label"/></content>
		</g:else>
		<link rel="stylesheet" href="${createLinkTo(dir:'js/jquery.tagsinput/',file:'jquery.tagsinput.css')}" type="text/css" media="screen, projection" />
		<script src="${createLinkTo(dir:'js/jquery.tagsinput/', file:'jquery.tagsinput.js')}" type="text/javascript" ></script>
        <style>
        #category_id_chosen {
            width: 100% !important;
        }
        </style>

    </head>
    <body>
        <div class="body">
            <g:if test="${flash.message}">
            	<div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${productInstance}">
	            <div class="errors">
	                <g:renderErrors bean="${productInstance}" as="list" />
	            </div>
            </g:hasErrors>
            
   			<g:if test="${productInstance?.id }">         
				<g:render template="summary" model="[productInstance:productInstance]"/>
			</g:if>
			
			<div style="padding: 10px">

                <div class="tabs tabs-ui">
					<ul>
						<li><a href="#tabs-details"><g:message code="product.details.label"/></a></li>
						<%-- Only show these tabs if the product has been created --%>
						<g:if test="${productInstance?.id }">
                            <li>
                                <a href="${request.contextPath}/product/productSuppliers/${productInstance?.id}" id="tab-sources">
                                    <g:message code="product.sources.label" default="Sources"/>
                                </a>
                            </li>
                            <li><a href="#tabs-manufacturer"><g:message code="product.manufacturer.label"/></a></li>
                            <li><a href="#tabs-status"><g:message code="product.stockLevel.label" default="Stock levels"/></a></li>
                            <%--<li><a href="#tabs-tags"><warehouse:message code="product.tags.label"/></a></li>--%>
                            <li><a href="#tabs-synonyms"><g:message code="product.synonyms.label"/></a></li>
                            <li><a href="#tabs-productGroups"><g:message code="product.substitutions.label" default="Substitutes"/></a></li>
							<li><a href="#tabs-packages"><g:message code="packages.label" default="Packages"/></a></li>
							<li><a href="#tabs-documents"><g:message code="product.documents.label" default="Documents"/></a></li>
                            <li><a href="#tabs-attributes"><g:message code="product.attributes.label" default="Attributes"/></a></li>
                            <li><a href="#tabs-components"><g:message code="product.components.label" default="Bill of Materials"/></a></li>
                        </g:if>
					</ul>	
					<div id="tabs-details" class="ui-tabs-hide">
                        <g:set var="formAction"><g:if test="${productInstance?.id}">update</g:if><g:else>save</g:else></g:set>
                        <g:form action="${formAction}" method="post">
                            <g:hiddenField name="id" value="${productInstance?.id}" />
                            <g:hiddenField name="version" value="${productInstance?.version}" />
                            <g:hiddenField name="categoryId" value="${params?.category?.id }"/>
                            <!--  So we know which category to show on browse page after submit -->

                            <div class="box" >
                                <h2>
                                    <warehouse:message code="product.productDetails.label" default="Product details"/>
                                </h2>
                                <table>
                                    <tbody>

                                        <%--
                                        <tr class="prop">
                                            <td class="name"><label for="name"><warehouse:message
                                                code="product.genericName.label" /></label></td>
                                            <td
                                                class="value ${hasErrors(bean: productInstance, field: 'genericProducts', 'errors')}">
                                                <ul>
                                                    <g:each var="productGroup" in="${productInstance?.productGroups }">
                                                        <li>
                                                            ${productGroup.description }
                                                            <g:link controller="productGroup" action="edit" id="${productGroup.id }">
                                                                <warehouse:message code="default.button.edit.label"/>
                                                            </g:link>
                                                        </li>
                                                    </g:each>
                                                </ul>
                                            </td>
                                        </tr>
                                        --%>

                                        <tr class="prop">
                                            <td class="name">
                                                <label for="active"><warehouse:message
                                                        code="product.active.label" /></label>
                                            </td>
                                            <td class="value middle ${hasErrors(bean: productInstance, field: 'active', 'errors')} ${hasErrors(bean: productInstance, field: 'essential', 'errors')}">
                                                <g:checkBox name="active" value="${productInstance?.active}" />
                                            </td>
                                        </tr>


                                        <tr class="prop first">
                                            <td class="name middle"><label for="productCode"><warehouse:message
                                                    code="product.productCode.label"/></label>

                                            </td>
                                            <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'productCode', 'errors')}">
                                                <g:textField name="productCode" value="${productInstance?.productCode}" size="50" class="medium text"
                                                             placeholder="${warehouse.message(code:'product.productCode.placeholder') }"/>
                                            </td>
                                        </tr>

                                        <tr class="prop first">
                                            <td class="name middle"><label for="name"><warehouse:message
                                                code="product.title.label" /></label></td>
                                            <td valign="top"
                                                class="value ${hasErrors(bean: productInstance, field: 'name', 'errors')}">
                                                <%--
                                                <g:textField name="name" value="${productInstance?.name}" size="80" class="medium text" />
                                                --%>
                                                <g:autoSuggestString id="name" name="name" size="80" class="text"
                                                    jsonUrl="${request.contextPath}/json/autoSuggest" value="${productInstance?.name?.encodeAsHTML()}"
                                                    placeholder="Product title (e.g. Ibuprofen, 200 mg, tablet)"/>
                                            </td>
                                        </tr>

                                        <tr class="prop">
                                            <td class="name middle">
                                              <label for="category.id"><warehouse:message code="product.primaryCategory.label" /></label>
                                            </td>
                                            <td valign="top" class="value ${hasErrors(bean: productInstance, field: 'category', 'errors')}">
                                                <g:selectCategory name="category.id" class="chzn-select" noSelection="['null':'']"
                                                                     value="${productInstance?.category?.id}" />


                                           </td>
                                        </tr>

                                        <tr class="prop">
                                            <td class="name middle"><label for="unitOfMeasure"><warehouse:message
                                                code="product.unitOfMeasure.label" /></label></td>
                                            <td
                                                class="value ${hasErrors(bean: productInstance, field: 'unitOfMeasure', 'errors')}">
                                                <%--
                                                <g:textField name="unitOfMeasure" value="${productInstance?.unitOfMeasure}" size="15" class="medium text"/>
                                                --%>
                                                <g:autoSuggestString id="unitOfMeasure" name="unitOfMeasure" size="80" class="text"
                                                    jsonUrl="${request.contextPath}/json/autoSuggest"
                                                    value="${productInstance?.unitOfMeasure}" placeholder="e.g. each, tablet, tube, vial"/>
                                            </td>
                                        </tr>

                                        <tr class="prop">
                                            <td class="name top"><label for="description"><warehouse:message
                                                code="product.description.label" /></label></td>
                                            <td
                                                class="value ${hasErrors(bean: productInstance, field: 'description', 'errors')}">
                                                <g:textArea name="description" value="${productInstance?.description}" class="medium text"
                                                    cols="80" rows="8"
                                                    placeholder="Detailed text description (optional)" />
                                            </td>
                                        </tr>
                                        <g:each var="attribute" in="${org.pih.warehouse.product.Attribute.list()}" status="status">
                                            <tr class="prop">
                                                <td class="name">
                                                    <label for="productAttributes.${attribute?.id}.value"><format:metadata obj="${attribute}"/></label>
                                                </td>
                                                <td class="value">
                                                    <g:set var="attributeFound" value="f"/>
                                                    <g:if test="${attribute.options}">
                                                        <select name="productAttributes.${attribute?.id}.value" class="attributeValueSelector chzn-select-deselect">
                                                            <option value=""></option>
                                                            <g:each var="option" in="${attribute.options}" status="optionStatus">
                                                                <g:set var="selectedText" value=""/>
                                                                <g:if test="${productInstance?.attributes[status]?.value == option}">
                                                                    <g:set var="selectedText" value=" selected"/>
                                                                    <g:set var="attributeFound" value="t"/>
                                                                </g:if>
                                                                <option value="${option}"${selectedText}>${option}</option>
                                                            </g:each>
                                                            <g:set var="otherAttVal" value="${productInstance?.attributes[status]?.value != null && attributeFound == 'f'}"/>
                                                            <g:if test="${attribute.allowOther || otherAttVal}">
                                                                <option value="_other"<g:if test="${otherAttVal}"> selected</g:if>>
                                                                    <g:message code="product.attribute.value.other" default="Other..." />
                                                                </option>
                                                            </g:if>
                                                        </select>
                                                    </g:if>
                                                    <g:set var="onlyOtherVal" value="${attribute.options.isEmpty() && attribute.allowOther}"/>
                                                    <g:textField class="otherAttributeValue text medium"
                                                                 style="${otherAttVal || onlyOtherVal ? '' : 'display:none;'}"
                                                                 name="productAttributes.${attribute?.id}.otherValue"
                                                                 value="${otherAttVal || onlyOtherVal ? productInstance?.attributes[status]?.value : ''}"/>
                                                </td>
                                            </tr>
                                        </g:each>
                                        <tr class="prop">
                                            <td class="name middle"><label for="upc"><warehouse:message
                                                    code="product.upc.label" /></label></td>
                                            <td class="value ${hasErrors(bean: productInstance, field: 'upc', 'errors')}">
                                                <g:textField name="upc" value="${productInstance?.upc}" size="50" class="medium text"/>
                                            </td>
                                        </tr>
                                        <tr class="prop">
                                            <td class="name middle"><label for="ndc"><warehouse:message
                                                    code="product.ndc.label" /></label></td>
                                            <td class="value ${hasErrors(bean: productInstance, field: 'ndc', 'errors')}">
                                                <g:textField name="ndc" value="${productInstance?.ndc}" size="50" class="medium text"
                                                             placeholder="e.g. 0573-0165"/>
                                            </td>
                                        </tr>
                                    <tr class="prop">
                                        <td class="name">
                                            <label><warehouse:message code="product.tags.label" default="Tags"></warehouse:message></label>
                                        </td>
                                        <td class="value">
                                            <g:textField id="tags1" class="tags" name="tagsToBeAdded" value="${productInstance?.tagsToString() }"/>
                                            <script>
                                                $(function() {
                                                    $('#tags1').tagsInput({
                                                        'autocomplete_url':'${createLink(controller: 'json', action: 'findTags')}',
                                                        'width': 'auto',
                                                        'height': '20px',
                                                        'removeWithBackspace' : true
                                                    });
                                                });
                                            </script>
                                        </td>
                                    </tr>



                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td></td>
                                            <td>
                                                <div>
                                                    <button type="submit" class="button icon approve">${warehouse.message(code: 'default.button.save.label', default: 'Save')}</button>
                                                    &nbsp;
                                                    <g:if test="${productInstance?.id }">
                                                        <g:link controller='inventoryItem' action='showStockCard' id='${productInstance?.id }' class="button icon remove">
                                                            ${warehouse.message(code: 'default.button.cancel.label', default: 'Cancel')}
                                                        </g:link>
                                                    </g:if>
                                                    <g:else>
                                                        <g:link controller="inventory" action="browse" class="button icon remove">
                                                            ${warehouse.message(code: 'default.button.cancel.label', default: 'Cancel')}
                                                        </g:link>
                                                    </g:else>
                                                </div>

                                            </td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>




                        </g:form>
                    </div>


                    <%-- Only show these tabs if the product has been created --%>
                    <g:if test="${productInstance?.id }">
                        <%--
                        <div id="tabs-tags" style="padding: 10px;" class="ui-tabs-hide">
                            <g:form controller="product" action="updateTags" method="post">
                                <g:hiddenField name="action" value="save"/>
                                <g:hiddenField name="id" value="${productInstance?.id}" />
                                <g:hiddenField name="version" value="${productInstance?.version}" />
                                <div class="box" >
                                    <h2>
                                        <warehouse:message code="product.tags.label" default="Product tags"/>
                                    </h2>
                                    <table>
                                        <tbody>
                                            <tr class="prop">

                                                <td class="value">
                                                    <g:textField id="tags1" class="tags" name="tagsToBeAdded" value="${productInstance?.tagsToString() }"/>
                                                    <script>
                                                        $(function() {
                                                            $('#tags1').tagsInput({
                                                                'autocomplete_url':'${createLink(controller: 'json', action: 'findTags')}',
                                                                'width': 'auto',
                                                                'height': '20px',
                                                                'removeWithBackspace' : true
                                                            });
                                                        });
                                                    </script>
                                                </td>
                                            </tr>
                                        </tbody>
                                        <tfoot>
                                            <tr>
                                                <td colspan="2">
                                                    <div class="center">
                                                        <button type="submit" class="button icon approve">
                                                            ${warehouse.message(code: 'default.button.save.label', default: 'Save')}
                                                        </button>
                                                        &nbsp;
                                                        <g:if test="${productInstance?.id }">
                                                            <g:link controller='inventoryItem' action='showStockCard' id='${productInstance?.id }' class="button icon arrowright">
                                                                ${warehouse.message(code: 'default.button.done.label', default: 'Done')}
                                                            </g:link>
                                                        </g:if>
                                                        <g:else>
                                                            <g:link controller="inventory" action="browse" class="button icon arrowright">
                                                                ${warehouse.message(code: 'default.button.done.label', default: 'Done')}
                                                            </g:link>
                                                        </g:else>
                                                    </div>

                                                </td>
                                            </tr>
                                        </tfoot>
                                    </table>

                                </div>
                            </g:form>
                        </div>
                     --%>
                        <div id="tabs-manufacturer" class="ui-tabs-hide">
                            <g:render template="manufacturers" model="[productInstance:productInstance]"/>

                        </div>

                        <div id="tabs-synonyms" class="ui-tabs-hide">
                            <div class="box">
                                <h2><warehouse:message code="product.synonyms.label" default="Synonyms"/></h2>
                                <g:render template="synonyms" model="[product: productInstance, synonyms:productInstance?.synonyms]"/>
                            </div>
                        </div>

                        <div id="tabs-productGroups" class="ui-tabs-hide">
                            <div class="box">
                                <h2><warehouse:message code="product.substitutions.label" default="Substitutions"/></h2>
                                <g:render template="productGroups" model="[product: productInstance, productGroups:productInstance?.productGroups]"/>
                            </div>
                        </div>
                        <div id="tabs-attributes" class="ui-tabs-hide">
                            <g:render template="attributes" model="[productInstance:productInstance]"/>
                        </div>
                        <div id="tabs-status" class="ui-tabs-hide">
                            <g:render template="inventoryLevels" model="[productInstance:productInstance]"/>
						</div>
                        <div id="tabs-components" class="ui-tabs-hide">
                            <g:render template="productComponents" model="[productInstance:productInstance]"/>
                        </div>
						<div id="tabs-documents" class="ui-tabs-hide">
                            <g:render template="documents" model="[productInstance:productInstance]"/>
						</div>
						<div id="tabs-packages" class="ui-tabs-hide">
                            <g:render template="productPackages" model="[productInstance:productInstance]"/>

						</div>
                        <div id="inventory-level-dialog" class="dialog hidden" title="Add a new stock level">
                            <g:render template="../inventoryLevel/form" model="[productInstance:productInstance,inventoryLevelInstance:new InventoryLevel()]"/>
                        </div>
                        <div id="uom-class-dialog" class="dialog hidden" title="Add a unit of measure class">
                            <g:render template="uomClassDialog" model="[productInstance:productInstance]"/>
						</div>
						<div id="uom-dialog" class="dialog hidden" title="Add a unit of measure">
                            <g:render template="uomDialog" model="[productInstance:productInstance]"/>
						</div>
                        <div id="product-package-dialog" class="dialog hidden" title="${packageInstance?.id?warehouse.message(code:'package.edit.label'):warehouse.message(code:'package.add.label') }">
                            <g:render template="productPackageDialog" model="[productInstance:productInstance,packageInstance:packageInstance]"/>
                        </div>
					</g:if>
				</div>	
			</div>
		</div>

        <g:each var="inventoryLevelInstance" in="${productInstance?.inventoryLevels}" status="i">
            <div id="inventory-level-${inventoryLevelInstance?.id}-dialog" class="dialog hidden" title="Edit inventory level">
                <g:render template="../inventoryLevel/form" model="[inventoryLevelInstance:inventoryLevelInstance]"/>
            </div>
        </g:each>
        <g:each var="packageInstance" in="${productInstance.packages }">
            <g:set var="dialogId" value="${'editProductPackage-' + packageInstance.id}"/>
            <div id="${dialogId}" class="dialog hidden" title="${packageInstance?.id?warehouse.message(code:'package.edit.label'):warehouse.message(code:'package.add.label') }">
                <g:render template="productPackageDialog" model="[dialogId:dialogId,productInstance:productInstance,packageInstance:packageInstance]"/>
            </div>
        </g:each>



    <%--
        <g:render template='category' model="['category':null,'i':'_clone','hidden':true]"/>
    --%>
		<script type="text/javascript">


            function updateSynonymTable(data) {
                console.log("updateSynonymTable");
                console.log(data);
            }


	    	$(document).ready(function() {
		    	$(".tabs").tabs(
	    			{
	    				cookie: {
	    					// store cookie for a day, without, it would be a session cookie
	    					expires: 1
	    				}
	    			}
				); 

                $(".open-dialog").livequery('click', function(event) {
				    event.preventDefault();
					var id = $(this).attr("dialog-id");
					$("#"+id).dialog({ autoOpen: true, modal: true, width: 800});
				});
                $(".close-dialog").livequery('click', function(event) {
                    event.preventDefault();
					var id = $(this).attr("dialog-id");
					$("#"+id).dialog('close');
				});

				$(".attributeValueSelector").change(function(event) {
					if ($(this).val() == '_other') {
						$(this).parent().find(".otherAttributeValue").show();
					}
					else {
						$(this).parent().find(".otherAttributeValue").val('').hide();
					}
				});

				function updateBinLocation() { 
					$("#binLocation").val('updated')
				}

				$(".binLocation").change(function(){ updateBinLocation() });
				
			});
		</script>
    </body>
</html>
