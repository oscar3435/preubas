public with sharing class AttachmentController {

	/**
	 * [decodeFileFromServer Executed in before insert]
	 * @param attachments [description]
	 */
	public void decodeFileFromServer(Attachment[] attachments){
		Set<Id> setIdParent = new Set<Id>();

		for(Attachment attachment:attachments){
			setIdParent.add(attachment.ParentId);
		}
		List<Attachment> attachmentList = new List<Attachment>();

		for(Attachment att_to_delete:[Select Id from Attachment where ParentId IN:setIdParent]){
			attachmentList.add(att_to_delete);
		}

		Map<String,String> keys					= new Map<String,String>();
		Map<String,Schema.SobjectType> describe	= Schema.getGlobalDescribe();

		for(String s:describe.keyset()){
			keys.put(describe.get(s).getDescribe().getKeyPrefix(),s);
		}

		for(Attachment attachment:attachments){  
			if(attachment.ParentId !=null){
				if(keys.get(String.valueOf(attachment.ParentId).substring(0,3))!=null){
	                if(keys.get(String.valueOf(attachment.ParentId).substring(0,3)) == 'estado_de_cuenta__c'){
	                    if(attachmentList.size()>0){
	                        delete attachmentList;		
	                    }			
	                    if(String.valueOf(URL.getCurrentRequestUrl()).toLowerCase().contains('services/soap')){
	                        if(attachment.body.toString()!=null){
	                            attachment.body = EncodingUtil.base64Decode(attachment.body.toString());

	                            // ### April 2017 | Edgar Moran : Adding new process to send email notifications	
	                            
	                        }    
	                    }
	                }
	            }
	        }
		}
	}

	/**
	 * [collectEstadosCuentaAndAttachments Executed in After inster]
	 * @param attachments [description]
	 */
	public void collectEstadosCuentaAndAttachments(Attachment[] attachments){

		System.debug('## Attachments after insert:'+ attachments);

		Set<Id> setEstadosDeCuentaIds             = new Set<Id>();
		Map<Id,Attachment> mapAttachments 		  = new Map<Id,Attachment>();
		Map<String,String> keys                   = new Map<String,String>();
		Map<String,Schema.SobjectType> describe   = Schema.getGlobalDescribe();

		for(String s:describe.keyset()){
			keys.put(describe.get(s).getDescribe().getKeyPrefix(),s);
		}

		for(Attachment attachment:attachments){
			setEstadosDeCuentaIds.add(attachment.ParentId);

			if(keys.get(String.valueOf(attachment.ParentId).substring(0,3))!=null){
				if(keys.get(String.valueOf(attachment.ParentId).substring(0,3)) == 'estado_de_cuenta__c'){
					mapAttachments.put(attachment.ParentId,attachment);
				}
			}
		}

		EstadoDeCuenta estadoCuentaController = new EstadoDeCuenta();
		estadoCuentaController.prepareEstadoDeCuentaPayload(setEstadosDeCuentaIds,mapAttachments);

		
	}
}