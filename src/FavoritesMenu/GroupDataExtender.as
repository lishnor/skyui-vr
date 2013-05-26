﻿import skyui.components.list.BasicList;
import skyui.components.list.IListProcessor;


class GroupDataExtender implements IListProcessor
{ 
  /* CONSTANTS */
  
  	public static var GROUP_SIZE = 32;
	

  /* PRIVATE VARIABLES */
  
	private var _formIdMap: Object;
	
	private var _groupButtons: Array;


  /* PROPERTIES */
  
	public var groupData: Array;
	public var mainHandData: Array;
	public var iconData: Array;
	
	
  /* INITIALIZATION */
	
	public function GroupDataExtender(a_groupButtons: Array)
	{
		groupData = [];
		mainHandData = [];
		iconData = [];
		_formIdMap = {};
		
		_groupButtons = a_groupButtons;
	}
	
	
  /* PUBLIC FUNCTIONS */
	
  	// @override IListProcessor
	public function processList(a_list: BasicList): Void
	{
		var entryList = a_list.entryList;
		
		// Create map for formid->entry and determine group icon
		for (var i = 0; i < entryList.length; i++) {
			var e = entryList[i];
			if (e.formId != null)
				_formIdMap[e.formId] = e;
		}
		
		processGroupData();
		processMainHandData();
		processIconData();
	}
	
	
  /* PRIVATE FUNCTIONS */
  
	private function processGroupData(): Void
	{
		// Set filterFlags for group membership
		var c = 0;
		var curFilterFlag = FilterDataExtender.FILTERFLAG_GROUP_0;
		
		for (var i=0; i<groupData.length; i++, c++) {
			if (c == GROUP_SIZE) {
				curFilterFlag = curFilterFlag << 1;
				c = 0;
			}
			
			var formId: Number = groupData[i];
			if (formId) {
				var t = _formIdMap[formId];
				if (t != null) {
					t.mainHandFlag = 0;
					t.filterFlag |= curFilterFlag;
				}
			}
		}
	}
  
	private function processMainHandData(): Void
	{
		// Set filterFlags for group membership
		var curMainHandFlag = FilterDataExtender.FILTERFLAG_GROUP_0;
		
		for (var i=0; i<mainHandData.length; i++) {
			var formId: Number = mainHandData[i];
			if (formId) {
				var t = _formIdMap[formId];
				if (t != null)
					t.mainHandFlag |= curMainHandFlag;
			}
			
			curMainHandFlag = curMainHandFlag << 1;
		}
	}

	private function processIconData(): Void
	{
		// Set icons (assumes iconDataExtender already set iconLabel)
		for (var i=0; i<iconData.length; i++) {
			var iconLabel: String;
			var formId: Number = iconData[i];
			if (formId) {
				var t = _formIdMap[formId];
				iconLabel = t.iconLabel ? t.iconLabel : "none";
			} else {
				iconLabel = "none";
			}
			_groupButtons[i].itemIcon.gotoAndStop(iconLabel);
		}
	}
}