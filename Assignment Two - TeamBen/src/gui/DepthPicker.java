package gui;

import static com.googlecode.javacv.cpp.opencv_core.cvCreateImage;
import static com.googlecode.javacv.cpp.opencv_core.cvGet2D;
import static com.googlecode.javacv.cpp.opencv_core.cvGetSize;
import static com.googlecode.javacv.cpp.opencv_imgproc.cvCanny;
import static com.googlecode.javacv.cpp.opencv_highgui.*;

import java.awt.Dimension;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.Rectangle;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.List;

import javax.swing.*;

import com.googlecode.javacv.cpp.opencv_core.CvMat;
import com.googlecode.javacv.cpp.opencv_core.IplImage;

public class DepthPicker extends JFrame	{
	private Squares squares;
	private IplImage canny;
	private IplImage depthImage;
	
	public DepthPicker() {
      super("Pick Depth Data Region");
      //setDefaultCloseOperation(exit());
      squares = new Squares();
      getContentPane().add(squares);
      pack();
      setLocationRelativeTo(null);
      //setVisible(true);
      this.setResizable(false);
   }
	
	public void setImage(IplImage depthImage) {
		this.depthImage = depthImage;
		canny = cvCreateImage(cvGetSize(depthImage), depthImage.depth(), 1);
		cvCanny(depthImage, canny, 30, 100, 3);
		
		squares.depthImage = depthImage.getBufferedImage();
		this.setSize(depthImage.width(), depthImage.height());
	}
	
   //public static void main(String[] args) {
   //   new DepthPicker();
   //}
   
   public ArrayList<Integer> getCoords() {
	   /**
	   if (squares.x == 0 || squares.y == 0 ||
			   squares.width == 0 || squares.height == 0) {
		   return null;
	   } else {
		   ArrayList<Integer> coords = new ArrayList<Integer>();
		   coords.add(squares.x); coords.add(squares.y);
		   coords.add(squares.width); coords.add(squares.height);
		   return coords;
	   }
	   */
	   
	   int gap = 0;
	   int x = 0; int y = 0;
	   for (x = depthImage.width()/2; x < depthImage.width(); x++) {
		   gap = 0;
		   for (y=100; y < depthImage.height(); y++) {
			   if (getPixelValue(depthImage, x, y)==0) {
				   break;
			   }
			   gap++;
		   }
		   if (gap >= 100) {
			   ArrayList<Integer> coords = new ArrayList<Integer>();
			   coords.add(x-10); coords.add(100);
			   coords.add(20); coords.add(y-100);
			   return coords;
		   }
	   }
	   
	   return null;
   }
   
   private static double getPixelValue(IplImage rgbImage, int x, int y) {
		return cvGet2D(rgbImage, y, x).getVal(2);
	}
}

class Squares extends JPanel implements MouseListener{
   public int PREF_W = 500;
   public int PREF_H = 500;
   private Rectangle rect = new Rectangle();
   
   public BufferedImage depthImage;
   
   int xStart, xFin, yStart, yFin = 0;
   int x, y, width, height = 0;

   public Squares() {
	   addMouseListener(this);
   }
   
   public void drawRectangle(int x, int y, int width, int height) {
	  super.repaint();
      rect = new Rectangle(x, y, width, height);
   }

   //@Override
   //public Dimension getPreferredSize() {
   //   return new Dimension(PREF_W, PREF_H);
   //}

   @Override
   protected void paintComponent(Graphics g) {
      super.paintComponent(g);
      Graphics2D g2 = (Graphics2D) g;
      
      if (depthImage != null) {
    	  g2.drawImage(depthImage, null, 0, 0);
      }
      g2.draw(rect);
   }
   
   @Override
   public void mouseClicked(MouseEvent arg0) {
   	
   }

   @Override
   public void mouseEntered(MouseEvent arg0) {
   	// TODO Auto-generated method stub
   	
   }

   @Override
   public void mouseExited(MouseEvent arg0) {
   	// TODO Auto-generated method stub
   	
   }

   @Override
   public void mousePressed(MouseEvent arg0) {
   	xStart = arg0.getX();
   	yStart = arg0.getY();
   }

   @Override
   public void mouseReleased(MouseEvent arg0) {
   	xFin = arg0.getX();
   	yFin = arg0.getY();
   	
   	if (xStart < xFin) {
   		x = xStart;
   		width = xFin-xStart;
   	} else {
   		x = xFin;
   		width = xStart-xFin;
   	}
   	
   	if (yStart < yFin) {
   		y = yStart;
   		height = yFin-yStart;
   	} else {
   		y = yFin;
   		height = yStart-yFin;
   	}
   	
   	drawRectangle(x, y, width, height);
   	
   }
}