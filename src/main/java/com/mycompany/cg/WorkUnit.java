package com.mycompany.cg;

/**
 * WorkUnit
 * @version 1.0
 */
public class WorkUnit implements Comparable<WorkUnit> {

	int projectId;
	int workerId;
	int workLoad;
	
	public WorkUnit(int projectId, int workerId, int workLoad) {
		
		super();
		this.projectId = projectId;
		this.workerId = workerId;
		this.workLoad = workLoad;
		
	}

	public int getProjectId() {
		return projectId;
	}

	public int getWorkerId() {
		return workerId;
	}

	public int getWorkLoad() {
		return workLoad;
	}

	@Override
	public String toString() {
		
		StringBuilder builder = new StringBuilder();
		if (workerId < 10) builder.append("  "); else builder.append(" ");
		builder.append(workerId);
		if (workLoad < 10) builder.append("  "); else builder.append(" ");
		builder.append(workLoad);
		
		return builder.toString();
		
	}

	@Override
	public int compareTo(WorkUnit object) {
		
		if (this.projectId == object.getProjectId()
			&& this.workLoad == object.getWorkLoad()
				&& this.workerId == object.getWorkerId())
					return 0;
		
		if (this.workLoad > object.getWorkLoad()) return 1;
		return -1;
		
	}
	
}
