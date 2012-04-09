/************************************************************************
 *
 * 1. This software is for the purpose of demonstrating one of many
 * ways to implement the algorithms in Introduction to Algorithms,
 * Second edition, by Thomas H. Cormen, Charles E. Leiserson, Ronald
 * L. Rivest, and Clifford Stein.  This software has been tested on a
 * limited set of test cases, but it has not been exhaustively tested.
 * It should not be used for mission-critical applications without
 * further testing.
 *
 * 2. McGraw-Hill licenses and authorizes you to use this software
 * only on a microcomputer located within your own facilities.
 *
 * 3. You will abide by the Copyright Law of the United Sates.
 *
 * 4. You may prepare a derivative version of this software provided
 * that your source code indicates that it based on this software and
 * also that you have made changes to it.
 *
 * 5. If you believe that you have found an error in this software,
 * please send email to clrs-java-bugs@mhhe.com.  If you have a
 * suggestion for an improvement, please send email to
 * clrs-java-suggestions@mhhe.com.
 *
 ***********************************************************************/

package com.mhhe.clrs2e;

import java.util.Iterator;

/** 
 * Implementation of a graph, using adjacency lists.
 *
 * <p>
 *
 * The number of vertices, cardV, is specified in the constructor
 * call, as is a flag indicating whether the graph is directed.  The
 * constructor creates an array <code>adj</code> of cardV objects.
 * When the graph is fully defined, each object in the
 * <code>adj</code> array is an {@link AdjacencyListGraph.AdjListInfo}
 * object, consisting of a {@link Vertex} and a reference to the first
 * edge in the list of edges incident on the vertex.  We reference a
 * <code>Vertex</code> object in each entry of <code>adj</code> so
 * that we can determine which vertex we're looking at as we traverse
 * the <code>adj</code> array.
 *
 * <p>
 *
 * Each edge is defined by an {@link AdjacencyListGraph.Edge} object,
 * which contains a reference to a <code>Vertex</code> (indicating the
 * adjacent vertex) and a reference to the next <code>Edge</code> in
 * the adjacency list (<code>null</code> if this <code>Edge</code>
 * object is the last one in the list).
 *
 * <p>
 *
 * If the graph is directed, then adding an edge (u,v) adds just
 * (u,v).  If, on the other hand, the graph is undirected, then adding
 * an edge (u,v) also adds the edge (v,u).  If the graph is
 * undirected, therefore, do not call <code>addEdge(u, v)</code> and
 * also <code>addEdge(v, u)</code>.
 *
 * <p>
 *
 * In method calls that require vertex arguments, you may refer to a
 * vertex either by its index (0 to cardV-1) or a reference to a
 * <code>Vertex</code> object.  (In method calls that require two
 * vertices as arguments, both must be indices or both must be
 * references to <code>Vertex</code> objects.)  When adding vertices
 * to the graph via the <code>addVertex</code> methods, you may
 * specify just the vertex's name, the name and index, or a
 * <code>Vertex</code> object.  If you give just the name, or you
 * specify a <code>Vertex</code> object that does not have an index,
 * the index used will be 1 greater than the index of the previous
 * vertex added.  (An index of 0 is used for the first vertex added.)
 *
 * <p>
 *
 * The normal way to create a graph is to first call the constructor,
 * then perform a sequence of <code>addVertex</code> calls to define
 * the vertices, and finally perform a sequence of
 * <code>addEdge</code> calls to define the edges in terms of the
 * added vertices.
 *
 * <p>
 *
 * This class provides two types of iterators: for iterating through
 * all the vertices and for iterating through the edges incident on a
 * given vertex.  The usual way of using these iterators is by the
 * following schema, where <code>g</code> references the graph:
 * <xmp>
 * Iterator vertexIter = g.vertexIterator();
 * while (vertexIter.hasNext()) {
 *     Vertex u = (Vertex) vertexIter.next();
 *     Iterator edgeIter = g.edgeIterator(u);
 *     while (edgeIter.hasNext()) {
 *         Vertex v = (Vertex) edgeIter.next();
 *         // Code that operates on edge (u,v) goes here.
 *         }
 * }
 * </xmp>
*/

public class AdjacencyListGraph implements Graph
{
    /** <code>true</code> if this graph is directed,
     * <code>false</code> if undirected. */
    protected boolean directed;

    /** The index of the last vertex added to this graph. */
    protected int lastAdded;

    /** How many edges this graph has. */
    protected int e;

    /** An array of adjacency lists. */
    protected AdjListInfo[] adj;

    /**
     * Creates an empty <code>AdjacencyListGraph</code>.
     *
     * @param cardV How many vertices this graph will have.
     * @param directed Flag indicating whether this graph is directed.
     */
    public AdjacencyListGraph(int cardV, boolean directed)
    {
	this.directed = directed;
	lastAdded = -1;
	adj = new AdjListInfo[cardV];
	e = 0;
    }

    /**
     * Adds a vertex to this graph.  Given the vertex's name, a
     * <code>Vertex</code> object is created and added.  The next
     * available index is used.
     *
     * @param name The vertex's name.
     * @return The new <code>Vertex</code> object added.
     */
    public Vertex addVertex(String name)
    {
	lastAdded++;		// the index for this vertex
	adj[lastAdded] = new AdjListInfo(new Vertex(lastAdded, name));
	return adj[lastAdded].thisVertex;
    }

    /**
     * Adds a vertex to this graph.  Given the vertex's name and
     * index, a <code>Vertex</code> object is created and added.
     *
     * @param index The vertex's index.
     * @param name The vertex's name.
     * @return The new <code>Vertex</code> object added.
     */
    public Vertex addVertex(int index, String name)
    {
	lastAdded = index;
	adj[lastAdded] = new AdjListInfo(new Vertex(lastAdded, name));
	return adj[lastAdded].thisVertex;
    }

    /**
     * Adds a vertex to this graph, given a <code>Vertex</object>.  If
     * the vertex's index is unknown, use the next available index.
     * Otherwise, use the index in the vertex.
     *
     * @param v The <code>Vertex</code> object to add.
     * @return <code>v</code>.
     */
    public Vertex addVertex(Vertex v)
    {
	if (v.getIndex() == Vertex.UNKNOWN_INDEX) {
	    lastAdded++;
	    v.setIndex(lastAdded);
	}
	else
	    lastAdded = v.getIndex();

	adj[lastAdded] = new AdjListInfo(v);
	return v;
    }	

    /**
     * Returns the vertex with a given index.
     *
     * @param index The index of the vertex.
     * @return The <code>Vertex</code> with the given index.
     */
    public Vertex getVertex(int index)
    {
	return adj[index].thisVertex;
    }

    /**
     * Adds an edge to this graph.  The edge is specified by a pair of
     * <code>Vertex</code> objects.
     *
     * @param u One vertex.
     * @param v The other vertex.
     */
    public void addEdge(Vertex u, Vertex v)
    {
	// Put v on u's list.
	int uIndex = u.getIndex();
	Edge x = new Edge(v, adj[uIndex].head);
	adj[uIndex].head = x;

	// If undirected, put u on v's list.
	if (!directed) {
	    int vIndex = v.getIndex();
	    x = new Edge(u, adj[vIndex].head);
	    adj[vIndex].head = x;
	}

	e++;
    }

    /**
     * Adds an edge to this graph.  The edge is specified by a pair of
     * vertex indices.
     *
     * @param u The index of one vertex.
     * @param v The index of the other vertex.
     */
    public void addEdge(int u, int v)
    {
	// Put v on u's list.
	Edge x = new Edge(adj[v].thisVertex, adj[u].head);
	adj[u].head = x;

	// If undirected, put u on v's list.
	if (!directed) {
	    x = new Edge(adj[u].thisVertex, adj[v].head);
	    adj[v].head = x;
	}

	e++;
    }

    /**
     * Inner class for the adjacency list array.
     */
    protected static class AdjListInfo
    {
	/** The vertex whose adjacency list this is. */
	public Vertex thisVertex;

	/** The first edge in this vertex's adjacency list. */
	public Edge head;

	/**
	 * Makes an AdjListInfo object for an empty list.
	 *
	 * @param v The vertex whose adjacency list this is.
	 */
	public AdjListInfo(Vertex v)
	{
	    thisVertex = v;
	    head = null;
	}
    }

    /**
     * Inner class for adjacency list edges.  Adjacency lists are
     * singly linked.
     */
    protected static class Edge
    {
	/** An adjacent vertex. */
	public Vertex vertex;

	/** The next edge in an adjacency list. */
	public Edge next;

	/**
	 * Creates a new edge.
	 *
	 * @param v The adjacent vertex.
	 * @param successor Successor edge to this one.
	 */
	public Edge(Vertex v, Edge successor)
	{
	    vertex = v;
	    next = successor;
	}
    }

    /** Returns an iterator that iterates though all the vertices in
     * the graph. */
    public Iterator vertexIterator()
    {
	return new VertexIterator();
    }    

    /** 
     * Inner class for a vertex iterator.
     */
    public class VertexIterator implements Iterator
    {
	/** The index of the vertex returned by the most recent call
	 * to <code>next</code>.  Initially, it is -1. */
	protected int lastVisited;

	/** Starts an iteration through the vertices. */
	public VertexIterator()
	{
	    lastVisited = -1;
	}

	/** Returns <code>true</code> if this vertex iterator has more
	 * vertices, <code>false</code> otherwise. */
	public boolean hasNext()
	{
	    return lastVisited < adj.length-1;
	}

	/** Returns the next vertex in the iteration. */
	public Object next()
	{
	    return adj[++lastVisited].thisVertex;
	}

	/**
	 * Unsupported.
	 *
	 * @throws UnsupportedOperationException always.
	 */
	public void remove()
	{
	    throw new UnsupportedOperationException();
	}
    }

    /**
     * Returns an iterator that iterates through the edges incident on
     * a given vertex.  Each incident edge is indicated by the
     * corresponding adjacent vertex.
     *
     * @param u The vertex whose incident edges are returned by the
     * iterator.
     */
    public Iterator edgeIterator(Vertex u)
    {
	return new EdgeIterator(u.getIndex());
    }

    /**
     * Returns an iterator that iterates through the edges incident on
     * a given vertex.  Each incident edge is indicated by the
     * corresponding adjacent vertex.
     *
     * @param u The index of the vertex whose incident edges are
     * returned by the iterator.
     */
    public Iterator edgeIterator(int u)
    {
	return new EdgeIterator(u);
    }

    /**
     * Inner class for an iterator that iterates through the edges
     * incident on a given vertex.
     */
    public class EdgeIterator implements Iterator
    {
	/** The edge returned by the most recent call to
	 * <code>next</code>.  Initially, it is <code>null</code>. */
	protected Edge current;

	/** The index of the vertex whose edges this iterator iterates
	 * through. */
	protected int index;

	/**
	 * Starts an iteration through the edges incident on a given
	 * vertex.
	 *
	 * @param v The index of the vertex.
	 */
	public EdgeIterator(int v)
	{
	    index = v;
	    current = null;
	}

	/** Returns <code>true</code> if this edge iterator has more
	 * edges, <code>false</code> otherwise. */
	public boolean hasNext()
	{
	    if (current == null)
		return adj[index].head != null;
	    else
		return current.next != null;
	}

	/** Returns the next edge in the iteration. */
	public Object next()
	{
	    if (current == null)
		current = adj[index].head;
	    else
		current = current.next;

	    return current.vertex;
	}

	/**
	 * Unsupported.
	 *
	 * @throws UnsupportedOperationException always.
	 */
	public void remove()
	{
	    throw new UnsupportedOperationException();
	}
    }

    /** Returns the number of vertices in this graph. */
    public int getCardV()
    {
	return adj.length;
    }

    /** Returns the number of edges in this graph. */
    public int getCardE()
    {
	return e;
    }

    /** Returns <code>true</code> if this graph is directed,
     * <code>false</code> if undirected. */
    public boolean isDirected()
    {
	return directed;
    }

    /** Creates and returns a graph that uses the same set of vertices
     * as this graph.  The created graph has no edges. */
    public AdjacencyListGraph useSameVertices()
    {
	// Start with an empty graph.
	AdjacencyListGraph newGraph = makeEmptyGraph(adj.length, directed);

	// Now add each vertex of this graph into the new graph, using
	// the same Vertex objects.
	for (int i = 0; i < adj.length; i++)
	    newGraph.addVertex(adj[i].thisVertex);

	return newGraph;
    }

    /**
     * Creates and returns an empty <code>AdjacencyListGraph</code>
     * with no edges, given the number of vertices and a boolean
     * indicating whether the graph is directed.
     *
     * @param cardV How many vertices in the new graph.
     * @param directed Flag indicating whether this graph is directed.
     */
    protected AdjacencyListGraph makeEmptyGraph(int cardV, boolean directed)
    {
	return new AdjacencyListGraph(cardV, directed);
    }

    /** Returns the <code>String</code> representation of this
     * graph. */
    public String toString()
    {
	String result = "";

	Iterator vertexIter = vertexIterator();
	while (vertexIter.hasNext()) {
	    Vertex u = (Vertex) vertexIter.next();
	    result += u + ":\n";

	    Iterator edgeIter = edgeIterator(u);
	    while (edgeIter.hasNext()) {
		Vertex v = (Vertex) edgeIter.next();
		result += "    " + v + "\n";
	    }
	}

	return result;
    }
}

// $Id: AdjacencyListGraph.java,v 1.1 2003/10/14 16:56:20 thc Exp $
// $Log: AdjacencyListGraph.java,v $
// Revision 1.1  2003/10/14 16:56:20  thc
// Initial revision.
//
